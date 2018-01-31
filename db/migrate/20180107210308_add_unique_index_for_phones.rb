class AddUniqueIndexForPhones < ActiveRecord::Migration[5.1]
  def change
    add_index :drivers, :phone_number, unique: true
    add_index :users, :phone_number, unique: true
  end
end
