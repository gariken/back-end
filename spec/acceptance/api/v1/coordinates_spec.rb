require 'acceptance_helper'

resource "Coordinates", acceptance: true do

  get "/api/v1/coordinates" do
    parameter :address, "Address"

    example "Get coordinates", document: :private do
      explanation "Get coordinates"

      do_request({address: "Россия, Москва, улица Космонавтов, 15"})
      expect(status).to eq 200
    end
  end

end
