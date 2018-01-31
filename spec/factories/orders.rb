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

FactoryBot.define do
  factory :order do
    lat_from 55.82173
    lat_to 55.766101
    lon_from 37.660269
    lon_to 37.640075
    address_from "Москва, Проспект мира, 10"
    address_to "Москва, Проспект мира, 150"
    amount 150
    distance 9
    waiting_minutes 10
    start_waiting_time (DateTime.now - 10.minute)
    payment_method 'cash'

    after(:create) do |order|
      order.user = create(:user)
      order.save
      payment = Payment.create!(
        description: "Оплата заказа №#{order.id}",
        amount: order.amount,
        user_id: order.user_id,
        order_id: order.id,
        payment_method: 'cash'
      )
    end

    factory :order_with_tariff do
      after(:create) do |order|
        order.tariff = create(:tariff)
        order.save
      end
    end
  end
end
