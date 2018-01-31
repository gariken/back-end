class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :phone_number, null: false
      t.string :encrypted_password, null: false
      t.string :name
      t.timestamps
    end
  end
end
