class AddRemovingStatusToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :removing_status, :integer, default: 0
  end
end
