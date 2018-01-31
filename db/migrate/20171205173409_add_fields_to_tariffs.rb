class AddFieldsToTariffs < ActiveRecord::Migration[5.1]
  def change
    add_column :tariffs, :name, :string
    add_column :tariffs, :status, :integer, default: 0
  end
end
