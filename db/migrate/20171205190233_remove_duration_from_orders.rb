class RemoveDurationFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :duration
  end
end
