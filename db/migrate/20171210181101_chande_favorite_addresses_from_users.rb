class ChandeFavoriteAddressesFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, column: :favorite_addresses
    change_column :users, :favorite_addresses, :string
  end
end
