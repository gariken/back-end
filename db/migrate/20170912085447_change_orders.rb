class ChangeOrders < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :lon_from, :decimal
    change_column :orders, :lon_to, :decimal
    change_column :orders, :lat_from, :decimal
    change_column :orders, :lat_to, :decimal
  end
end
