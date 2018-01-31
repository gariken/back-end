class AddBelogsToTariffForOrdersAndDrivers < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :tariff
    remove_column :drivers, :car_category
    add_reference :orders, :tariff, foreign_key: true
    add_reference :drivers, :tariff, foreign_key: true
  end
end
