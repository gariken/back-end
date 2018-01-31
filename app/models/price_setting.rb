# == Schema Information
#
# Table name: price_settings
#
#  id                             :integer          not null, primary key
#  singleton_guard                :integer          not null
#  waiting_price                  :float            not null
#  price_per_kilometer            :float            not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  percentage_of_driver           :float
#  free_waiting_minutes           :integer
#  driver_rate_increase_by_orders :float
#  max_driver_rate                :float
#  driver_rate_increase_by_rating :float
#  coef_for_economy               :float
#  coef_for_comfort               :float
#  min_order_amount               :float
#  driver_rate_increase_by_photo  :float
#
# Indexes
#
#  index_price_settings_on_singleton_guard  (singleton_guard) UNIQUE
#

class PriceSetting < ApplicationRecord
  validates :singleton_guard, inclusion: { in: [0] }
  validates :waiting_price, :price_per_kilometer, :percentage_of_driver, :free_waiting_minutes, :driver_rate_increase_by_rating,
            :driver_rate_increase_by_orders, :coef_for_comfort, :coef_for_economy, :min_order_amount, :driver_rate_increase_by_photo,
             presence: true

  def self.instance
    begin
      find(1)
    rescue ActiveRecord::RecordNotFound
      price_setting = PriceSetting.new
      price_setting.singleton_guard = 0
      price_setting.waiting_price = 10
      price_setting.price_per_kilometer = 10
      price_setting.percentage_of_driver = 0.3
      price_setting.free_waiting_minutes = 10
      price_setting.driver_rate_increase_by_orders = 0.01
      price_setting.driver_rate_increase_by_rating = 0.02
      price_setting.driver_rate_increase_by_photo = 0.01
      price_setting.max_driver_rate = 0.7
      price_setting.coef_for_comfort = 1.2
      price_setting.coef_for_economy = 0.9
      price_setting.min_order_amount = 100
      price_setting.save!
      price_setting
    end
  end

  def self.method_missing(method, *args)
    if PriceSetting.instance.methods.include?(method)
      PriceSetting.instance.send(method, *args)
    else
      super
    end
  end

end
