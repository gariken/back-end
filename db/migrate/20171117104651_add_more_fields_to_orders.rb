class AddMoreFieldsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :time_of_taking, :datetime
    add_column :orders, :start_waiting_time, :datetime
    add_column :orders, :time_of_starting, :datetime
    add_column :orders, :time_of_closing, :datetime
    add_column :orders, :duration, :float
    add_column :orders, :with_child_seat, :boolean
    add_column :orders, :with_animals, :boolean
    add_column :orders, :intermediate_points, :string, array: true, default: []
    add_column :orders, :tariff, :string
    add_index :orders, :intermediate_points, using: 'gin'
  end
end

