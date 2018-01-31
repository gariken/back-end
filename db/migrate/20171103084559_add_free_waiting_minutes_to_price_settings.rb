class AddFreeWaitingMinutesToPriceSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :price_settings, :free_waiting_minutes, :integer
  end
end
