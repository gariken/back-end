class ChangeDriverFieldsFromPriceSettings < ActiveRecord::Migration[5.1]
  def change
    rename_column :price_settings, :rate_increase, :driver_rate_increase_by_orders
    add_column :price_settings, :driver_rate_increase_by_rating, :float
  end
end
