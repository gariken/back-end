class AddNightFieldsToTariffs < ActiveRecord::Migration[5.1]
  def change
    add_column :tariffs, :night_price_per_kilometer, :float
  end
end
