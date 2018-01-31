class CreateOrderOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :order_options do |t|
      t.string :body
    end
  end
end
