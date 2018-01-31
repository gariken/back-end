class AddExpToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :expiration_date, :string, null: false
  end
end
