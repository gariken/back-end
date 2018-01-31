class CreatePriceSetting < ActiveRecord::Migration[5.1]
  def change
    create_table :price_settings do |t|
      t.integer :singleton_guard, null: false
      t.float :waiting_price, null: false
      t.float :price_per_kilometer, null: false
      t.timestamps null: false
    end

    add_index(:price_settings, :singleton_guard, unique: true)
  end
end
