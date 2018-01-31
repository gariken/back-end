require 'acceptance_helper'

resource "PriceSetting", acceptance: true do

  get "/api/v1/price_setting" do
    parameter :waiting_price, "price per minute of waiting"
    parameter :price_per_kilometer, "price per kilometer"
    parameter :percentage_of_driver, "percentage of driver"
    parameter :free_waiting_minutes, "free waiting minutes"
    parameter :driver_rate_increase_by_rating
    parameter :driver_rate_increase_by_orders
    parameter :coef_for_economy
    parameter :coef_for_comfort

    example "Get price settings", document: :private do
      explanation "Get price settings"

      do_request
      expect(status).to eq 200
    end
  end

end
