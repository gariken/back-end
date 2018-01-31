class SetCoordinatesNullTrueForOrders < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :lat_from, :decimal, null: true
    change_column :orders, :lat_to, :decimal, null: true
    change_column :orders, :lon_from, :decimal, null: true
    change_column :orders, :lon_to, :decimal, null: true
  end
end
