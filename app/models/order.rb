# == Schema Information
#
# Table name: orders
#
#  id                  :integer          not null, primary key
#  lat_from            :decimal(, )
#  lon_from            :decimal(, )
#  lat_to              :decimal(, )
#  lon_to              :decimal(, )
#  user_id             :integer
#  driver_id           :integer
#  status              :integer          default("opened")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  comment             :string
#  rating              :integer
#  amount              :float
#  address_from        :string
#  address_to          :string
#  distance            :float
#  waiting_minutes     :integer
#  time_of_taking      :datetime
#  start_waiting_time  :datetime
#  time_of_starting    :datetime
#  time_of_closing     :datetime
#  intermediate_points :string           default([]), is an Array
#  payment_method      :integer
#  tariff_id           :integer
#  removing_status     :integer          default("active")
#  review              :string
#
# Indexes
#
#  index_orders_on_driver_id            (driver_id)
#  index_orders_on_intermediate_points  (intermediate_points)
#  index_orders_on_tariff_id            (tariff_id)
#  index_orders_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tariff_id => tariffs.id)
#

class Order < ApplicationRecord
  attr_accessor :user_name, :phone_number, :user_surname

  validates :lat_to, :lat_from, :lon_to, :lon_from, :address_from, :address_to, :amount, :distance,
            :payment_method, presence: true

  belongs_to :user, optional: true
  belongs_to :driver, optional: true
  belongs_to :tariff, optional: true

  has_one :payment, dependent: :destroy

  has_and_belongs_to_many :order_options

  enum status: %i(opened closed)
  enum payment_method: %i(cash cashless)
  enum removing_status: %i(active inactive)

  def close(payed)
    tariff = self.tariff

    self.update(amount: self.amount + (self.waiting_minutes - tariff.free_waiting_minutes) * tariff.waiting_price) if (self.waiting_minutes - tariff.free_waiting_minutes) > 0
    self.update(status: 'closed', time_of_closing: DateTime.now)

    driver = self.driver
    points_for_order = 10
    points_for_order += 5 * (self.distance / 10).to_i if self.distance >= 10

    interest_rate = tariff.percentage_of_driver

    driver_orders = driver.orders

    interest_rate += tariff.driver_rate_increase_by_orders if driver_orders.size % 200.0 == 0
    interest_rate += tariff.driver_rate_increase_by_rating if driver.rating >= 4.5 && driver_orders.size > 100
    interest_rate += tariff.driver_rate_increase_by_photo if driver.photo
    interest_rate = tariff.max_driver_rate if interest_rate > tariff.max_driver_rate

    if DateTime.current + 1.month > driver.created_at
      if self.payment_method == 'cash'
        driver.update(
          points: driver.points + points_for_order,
          balance: driver.balance
        )
      elsif self.payment_method == 'cashless'
        driver.update(
          points: driver.points + points_for_order,
          balance: driver.balance + self.amount
        )
      end
    else
      if self.payment_method == 'cash'
        commission = 1 - interest_rate
        amount_with_commission = self.amount * commission > tariff.max_commission ? tariff.max_commission : self.amount * commission

        driver.update(
          points: driver.points + points_for_order,
          balance: driver.balance - amount_with_commission
        )
      elsif self.payment_method == 'cashless'
        driver.update(
          points: driver.points + points_for_order,
          balance: driver.balance + self.amount * interest_rate
        )
      end
    end

    payment = self.payment.pay_order if payed

    CloseOrdersChannel.broadcast_to(
      self.user,
      order: self.attributes.merge({ order_options: self.order_options })
    )

    if payment[:error].nil?
      self
    else
      { errors: payment[:message] }
    end
  end

  def take(driver_id)
    unless Driver.find(driver_id).orders.pluck(:status).include? 'opened'
      self.update(driver_id: driver_id, time_of_taking: DateTime.now)
      TakeOrdersChannel.broadcast_to(
        self.user,
        { order: self, driver: self.driver }
      )
      drivers = Driver.drivers_with_higher_tariffs_ids(self.tariff)
      notify_about_taking(self, drivers) unless drivers.blank?
      User.send_push_about_taking(self) if self.driver
      self
    else
      { errors: 'Driver has open orders' }
    end
  end

  def estimate(order_rating, review)
    self.update(rating: order_rating, review: review)
    driver = self.driver
    estimated_orders_of_driver = Order.where('rating is not null AND driver_id = ?', driver.id)
    if driver.rating == 0
      driver.update(rating: order_rating.to_f)
    else
      order_ratings = estimated_orders_of_driver.pluck(:rating)
      driver.update(rating: (order_ratings.inject(0){|sum,x| sum + x }/order_ratings.size.to_f).round(2))
    end
    driver.update(points: driver.points + 5) if order_rating.to_f == 5
    self
  end

  def start_driving
    self.update(time_of_starting: DateTime.now, waiting_minutes: ((DateTime.now - self.start_waiting_time.to_datetime) * 24 * 60).to_i)
    unless self.user_id.nil?
      DrivingStartChannel.broadcast_to(
        self.user,
        order: self.attributes.merge({ order_options: self.order_options })
      )
    end
    self
  end

  def start_waiting
    self.update(start_waiting_time: DateTime.now)
    unless self.user_id.nil?
      WaitingStartChannel.broadcast_to(
        self.user,
        order: self.attributes.merge({ order_options: self.order_options })
      )
    end
    User.send_push_about_coming(self) if self.driver
    self
  end

  def cancel(sender)
    if !self.user_id.nil? && sender.class.to_s == 'Driver'
      CancelOrdersForUsersChannel.broadcast_to(
        self.user,
        order: self.attributes.merge({ order_options: self.order_options })
      )
    end

    if !self.driver_id.nil? && sender.class.to_s == 'User'
      CancelOrdersChannel.broadcast_to(
        self.driver,
        order: self.attributes.merge({ order_options: self.order_options })
      )
    end

    if self.driver_id.nil? && sender.class.to_s == 'User'
      drivers = Driver.drivers_with_higher_tariffs_ids(self.tariff)
      notify_about_canceling(self, drivers) unless drivers.blank?
    end


    self.destroy
    self
  end

  private

    def notify_about_canceling(order, drivers)
      drivers.each do |driver|
        CancelOrdersForDriversChannel.broadcast_to(
          driver,
          order: self.attributes.merge({ order_options: self.order_options })
        )
      end
    end

    def notify_about_taking(order, drivers)
      drivers.each do |driver|
        TakeOrdersForDriversChannel.broadcast_to(
          driver,
          order: self.attributes.merge({ order_options: self.order_options })
        )
      end
    end
end
