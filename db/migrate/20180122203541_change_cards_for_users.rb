class ChangeCardsForUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :payments_token
    remove_column :users, :card_is_binded

    create_table :cards do |t|
      t.string :last_four_numbers, null: false
      t.string :token, null: false
      t.belongs_to :user
      t.timestamps
    end
  end
end
