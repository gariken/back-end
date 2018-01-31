class RemoveRateFieldsFromDrivers < ActiveRecord::Migration[5.1]
  def change
    remove_column :drivers, :interest_rate
    remove_column :drivers, :increased_interest_rate_by_rating
  end
end
