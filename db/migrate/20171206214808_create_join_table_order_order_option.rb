class CreateJoinTableOrderOrderOption < ActiveRecord::Migration[5.1]
  def change
    create_join_table :orders, :order_options do |t|
      t.index [:order_id, :order_option_id]
    end
  end
end
