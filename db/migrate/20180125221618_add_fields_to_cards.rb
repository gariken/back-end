class AddFieldsToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :card_type, :string
    add_column :cards, :card_type_code, :integer
    add_column :cards, :issuer, :string
    add_column :cards, :issuer_bank_country, :string
  end
end
