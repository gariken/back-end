class AddReviewToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :review, :string
  end
end
