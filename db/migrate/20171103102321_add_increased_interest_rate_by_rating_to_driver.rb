class AddIncreasedInterestRateByRatingToDriver < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :increased_interest_rate_by_rating, :boolean, default: false
  end
end
