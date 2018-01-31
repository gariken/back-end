class RemoveFieldsFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :options
    remove_column :orders, :with_animals
    remove_column :orders, :with_child_seat
  end
end
