class ChangeFavoriteAddressesType < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :favorite_addresses, :string, default: ""
  end
end
