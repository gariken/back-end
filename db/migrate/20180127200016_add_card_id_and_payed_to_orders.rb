class AddCardIdAndPayedToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :status, :integer, default: 0
    add_column :payments, :card_id, :integer
    add_column :payments, :payment_method, :integer
  end
end
