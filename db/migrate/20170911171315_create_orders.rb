class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :lat_from, null: false
      t.integer :lon_from, null: false
      t.integer :lat_to, null: false
      t.integer :lon_to, null: false
      t.belongs_to :user
      t.belongs_to :driver
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
