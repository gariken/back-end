require 'rails_helper'

RSpec.describe Api::V1::CoordinatesController, type: :controller do

  describe "GET #show" do
    it "returns coordinates" do
      get :show, params: {address: "Россия, Москва, улица Космонавтов, 15"}
      resp = JSON.parse(response.body)
      expect(resp['data']['coordinates']).to eq([55.82173, 37.660269])
    end
  end
end
