class AddMoreFieldsToPriceSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :price_settings, :min_order_amount, :float
    add_column :price_settings, :driver_rate_increase_by_photo, :float
  end
end
