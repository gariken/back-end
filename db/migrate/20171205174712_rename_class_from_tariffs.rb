class RenameClassFromTariffs < ActiveRecord::Migration[5.1]
  def change
    rename_column :tariffs, :class, :position
  end
end
