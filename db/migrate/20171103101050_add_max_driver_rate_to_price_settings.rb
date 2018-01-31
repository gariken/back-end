class AddMaxDriverRateToPriceSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :price_settings, :max_driver_rate, :float
  end
end
