class AddCarColorToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :car_color, :string
  end
end
