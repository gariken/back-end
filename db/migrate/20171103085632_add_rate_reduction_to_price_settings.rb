class AddRateReductionToPriceSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :price_settings, :rate_reduction, :float
  end
end
