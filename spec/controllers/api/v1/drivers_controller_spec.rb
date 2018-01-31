require 'rails_helper'

RSpec.describe Api::V1::DriversController, type: :controller do

  login_driver

  before do
    @driver = create(:driver)
  end

  describe "GET #show" do
    it "assigns the driver as @driver" do
      get :show, params: {id: @driver.id}
      expect(assigns(:driver)).to eq(@driver)
    end
  end

  describe "PUT #update" do
    it "updates an driver" do
      post :update, params: {id: @driver.id, surname: "Surname"}
      @driver.reload
      expect(@driver.surname).to eq('Surname')
    end
  end

  describe "POST #initialization" do
    it "sets driver coordinates in redis" do
      post :initialization, params: {id: @driver.id, lat: 12.344312, lon: 15.231432}
      expect(@driver.coordinates).to eq([12.344312, 15.231432])
    end
  end
end
