class AddStatusToOrderOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_options, :status, :integer, default: 0
  end
end
