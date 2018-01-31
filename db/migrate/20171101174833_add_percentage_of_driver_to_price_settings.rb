class AddPercentageOfDriverToPriceSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :price_settings, :percentage_of_driver, :float
  end
end
