class AddFieldsToUsersAndDriversAndOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sex, :integer
    add_column :users,  :surname, :string

    add_column :drivers, :licence_plate, :string
    add_column :drivers, :car_image, :string
    add_column :drivers, :car_model, :string
    add_column :drivers, :car_category, :integer
    add_column :drivers, :surname, :string
    add_column :drivers, :balance, :float
    add_column :drivers, :passport, :string
    add_column :drivers, :points, :integer

    add_column :orders, :comment, :string
    add_column :orders, :rating, :integer
  end
end
