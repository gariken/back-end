class AddMaxCommissionToTariffs < ActiveRecord::Migration[5.1]
  def change
    add_column :tariffs, :max_commission, :float
  end
end
