class AddCardIsBindedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :card_is_binded, :boolean, default: false
  end
end
