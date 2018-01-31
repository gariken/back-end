require 'acceptance_helper'

resource "Order options", acceptance: true do

  get "/api/v1/order_options" do
    example "Get all order options", document: :private do
      explanation "Get all order options"

      opt1 = create(:order_option)
      opt2 = create(:order_option)
      do_request()
      expect(status).to eq 200
    end
  end

end
