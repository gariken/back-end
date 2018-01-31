# == Schema Information
#
# Table name: tariffs
#
#  id                             :integer          not null, primary key
#  waiting_price                  :float
#  price_per_kilometer            :float
#  percentage_of_driver           :float
#  free_waiting_minutes           :integer
#  driver_rate_increase_by_orders :float
#  max_driver_rate                :float
#  driver_rate_increase_by_rating :float
#  min_order_amount               :float
#  driver_rate_increase_by_photo  :float
#  position                       :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  name                           :string
#  status                         :integer          default("active")
#  priority                       :integer
#  max_commission                 :float
#  night_price_per_kilometer      :float
#

FactoryBot.define do
  factory :tariff do
    waiting_price 20.0
    price_per_kilometer 50.0
    percentage_of_driver 0.5
    free_waiting_minutes 15
    driver_rate_increase_by_orders 0.01
    max_driver_rate 0.7
    driver_rate_increase_by_rating 0.01
    min_order_amount 120.0
    driver_rate_increase_by_photo 0.01
    max_commission 100
    position 1
    priority 1
    night_price_per_kilometer 100
    name "Тариф"
  end
end
