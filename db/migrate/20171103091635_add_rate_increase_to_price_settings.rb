class AddRateIncreaseToPriceSettings < ActiveRecord::Migration[5.1]
  def change
    rename_column :price_settings, :rate_reduction, :rate_increase
  end
end
