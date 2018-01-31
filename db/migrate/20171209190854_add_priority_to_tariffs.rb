class AddPriorityToTariffs < ActiveRecord::Migration[5.1]
  def change
    add_column :tariffs, :priority, :integer
  end
end
