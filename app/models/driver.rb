# == Schema Information
#
# Table name: drivers
#
#  id                 :integer          not null, primary key
#  phone_number       :string           not null
#  encrypted_password :string           not null
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  licence_plate      :string
#  photo              :string
#  car_model          :string
#  surname            :string
#  balance            :float
#  license            :string
#  points             :integer
#  confirmed          :boolean          default(FALSE)
#  rating             :float
#  status             :integer          default("active")
#  bonus_on_this_week :boolean          default(FALSE)
#  tariff_id          :integer
#  car_color          :string
#
# Indexes
#
#  index_drivers_on_phone_number  (phone_number) UNIQUE
#  index_drivers_on_tariff_id     (tariff_id)
#
# Foreign Keys
#
#  fk_rails_...  (tariff_id => tariffs.id)
#

class Driver < ApplicationRecord
  validates :phone_number, :encrypted_password, presence: true
  validates :phone_number, uniqueness: true
  validates :phone_number, length: { is: 11 }

  mount_uploader :photo, ImageUploader
  mount_uploader :license, ImageUploader

  devise :database_authenticatable

  belongs_to :tariff, optional: true

  has_many :orders

  enum car_category: %i(economy comfort)
  enum status: %i(active inactive)

  def coordinates=(coordinates)
    Redis.current.set("#{self.id}_driver_coordinates", coordinates.to_json)
  end

  def coordinates
    JSON.parse(Redis.current.get("#{self.id}_driver_coordinates")).map { |coordinate| coordinate.to_f }
  end

  def online?
    self.updated_at > 15.minutes.ago
  end

  def self.notify_about_order(order, tariff)
    drivers = Driver.drivers_with_higher_tariffs_ids(tariff)
    notify(order, drivers) unless drivers.blank?
    drivers
  end

  def self.send_pushes_about_order(tariff)
    Tariff.where("priority >= ?", tariff.priority).pluck(:id).each do |tariff_id|
      PushSendingJob.perform_later(
        "orders_drivers_#{tariff_id}",
        "Новый заказ",
        "Доступен новый заказ."
      )
    end
  end

  def self.drivers_with_higher_tariffs_ids(starting_tariff)
    Driver.where("tariff_id IN (?) AND updated_at > ? AND status = ?", Tariff.where("priority >= ?", starting_tariff.priority).pluck(:id), 15.minutes.ago, 0)
  end

  private

    def self.notify(order, drivers)
      drivers.each do |driver|
        OrdersChannel.broadcast_to(
          driver,
          order: order.attributes.merge({ order_options: order.order_options })
        )
      end
    end
end
