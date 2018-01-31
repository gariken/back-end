class AddPriceToOrderOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_options, :price, :float
  end
end
