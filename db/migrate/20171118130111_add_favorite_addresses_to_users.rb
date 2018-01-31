class AddFavoriteAddressesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :favorite_addresses, :jsonb, default: {}
    add_index :users, :favorite_addresses, using: 'gin'
  end
end
