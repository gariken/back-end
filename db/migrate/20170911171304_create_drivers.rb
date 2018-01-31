class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.string :phone_number, null: false
      t.string :encrypted_password, null: false
      t.string :name
      t.timestamps
    end
  end
end
