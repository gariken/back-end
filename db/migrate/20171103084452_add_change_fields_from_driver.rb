class AddChangeFieldsFromDriver < ActiveRecord::Migration[5.1]
  def change
    rename_column :drivers, :passport, :license
    rename_column :drivers, :car_image , :photo

    add_column :drivers, :rating, :float
    add_column :drivers, :interest_rate, :float
    add_column :drivers, :status, :integer, default: 0
  end
end
