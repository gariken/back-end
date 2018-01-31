class AddFieldsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :amount, :float
    add_column :orders, :options, :string
  end
end
