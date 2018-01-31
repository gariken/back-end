class AddWaitingMinutesToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :waiting_minutes, :integer
  end
end
