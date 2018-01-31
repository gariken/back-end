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

class Tariff < ApplicationRecord
  validates :waiting_price, :price_per_kilometer, :percentage_of_driver, :free_waiting_minutes, :driver_rate_increase_by_rating,
            :driver_rate_increase_by_orders, :min_order_amount, :driver_rate_increase_by_photo, :name, :position,
            :max_driver_rate, :max_commission, :night_price_per_kilometer, presence: true
  validates :percentage_of_driver, :max_driver_rate, :driver_rate_increase_by_orders,
            :driver_rate_increase_by_photo, :driver_rate_increase_by_rating, numericality: { less_than_or_equal_to: 1 }

  has_many :orders
  has_many :drivers

  enum status: %i(active inactive)
end
