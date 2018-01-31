class CreateTariffs < ActiveRecord::Migration[5.1]
  def change
    create_table :tariffs do |t|
      t.float :waiting_price
      t.float :price_per_kilometer
      t.float :percentage_of_driver
      t.integer :free_waiting_minutes
      t.float :driver_rate_increase_by_orders
      t.float :max_driver_rate
      t.float :driver_rate_increase_by_rating
      t.float :min_order_amount
      t.float :driver_rate_increase_by_photo
      t.integer :class
      t.timestamps null: false
    end
  end
end
