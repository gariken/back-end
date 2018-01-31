class RenameBodyFromOrderOptions < ActiveRecord::Migration[5.1]
  def change
    rename_column :order_options, :body, :description
  end
end
