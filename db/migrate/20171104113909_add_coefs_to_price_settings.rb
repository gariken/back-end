class AddCoefsToPriceSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :price_settings, :coef_for_economy, :float
    add_column :price_settings, :coef_for_comfort, :float
  end
end
