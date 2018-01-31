require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :controller do

  describe "GET #show" do
    it "returns address" do
      get :show, params: {lat: 55.82173, lon: 37.660269}
      resp = JSON.parse(response.body)
      expect(resp['data']['address']).to eq("Россия, Москва, улица Космонавтов, 15")
    end
  end
end
