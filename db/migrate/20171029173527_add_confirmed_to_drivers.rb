class AddConfirmedToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :confirmed, :boolean, default: false
  end
end
