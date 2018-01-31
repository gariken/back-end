class AddBonusOnThisFridayToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :bonus_on_this_week, :boolean, default: false
  end
end
