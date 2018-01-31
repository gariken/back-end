require 'acceptance_helper'

resource "Tariffs", acceptance: true do

  get "/api/v1/tariffs" do
    example "Get all tariffs", document: :private do
      explanation "Get all tariffs"

      tariff1 = create(:tariff)
      tariff2 = create(:tariff)
      do_request()
      expect(status).to eq 200
    end
  end

end
