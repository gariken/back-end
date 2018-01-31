class AddAddressesAndDistanceToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :address_from, :string
    add_column :orders, :address_to, :string
    add_column :orders, :distance, :float
  end
end
