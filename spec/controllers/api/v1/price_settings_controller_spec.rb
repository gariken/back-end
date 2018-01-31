require 'rails_helper'

RSpec.describe Api::V1::PriceSettingsController, type: :controller do

  describe "GET #show" do
    it "return price setting" do
      get :show
      resp = JSON.parse(response.body)
      expect(resp['data']['price_setting']['waiting_price']).to eq 10
      expect(resp['data']['price_setting']['price_per_kilometer']).to eq 10
    end
  end
end
