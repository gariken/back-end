class AddPaymentFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email, :string
    add_column :users, :payments_token, :string
  end
end
