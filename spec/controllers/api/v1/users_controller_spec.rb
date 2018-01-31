require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  login_user

  before do
    @user = create(:user)
  end

  describe "GET #show" do
    it "assigns the user as @user" do
      get :show, params: {id: @user.id}
      expect(assigns(:user)).to eq(@user)
    end
  end

  describe "PUT #update" do
    it "updates an user" do
      post :update, params: {id: @user.id, surname: "Surname"}
      @user.reload
      expect(@user.surname).to eq('Surname')
    end
  end

  describe "POST #initialization" do
    it "sets user coordinates in redis" do
      post :initialization, params: {id: @user.id, lat: 12.344312, lon: 15.231432}
      expect(@user.coordinates).to eq([12.344312, 15.231432])
    end
  end

  describe "POST #bind_card" do
    it "creates bank card without 3ds" do
      post :bind_card, params: {id: @user.id, name: "VASYA PUPKIN", card_cryptogram_packet: "024111111111200504H66InXlyndJGvarKvdUYX75CfFpskkWgrsULsm21OzY0iGvnpPVnEc1042ozRamxlBdFG2mFA62efh4C5cA/KtimunlO91aT7XzBOe3dbBvY9h3QZ/Y9FMZk8Aa+xuItudiGgFWMIFUx0e0vRXV0zK/aMaausgUsFhNTyTBsUSWTT3XUzlX+OHxblr0OZCt6yXS78q6PJxTtI23B2mPPTpPLiuSnFzdOfOAFEVVH0AegZQ5LpjXgOvktTBB0H7ObUaGlHit3bhQB+Q/99I94oqL0FT8JeEuwyfCcN74O5S1496hAJdE472Q88UByve/x1E8WaUFqWRxncyZQBLCTsw=="}
      resp = JSON.parse(response.body)
      expect(resp["data"]["code"]).to eq(0)
      expect(resp["data"]["message"]).to eq("Оплата успешно проведена")
      expect(@user.cards).not_to eq([])
    end

    it "creates bank card with 3ds" do
      post :bind_card, params: {id: @user.id, name: "VASYA PUPKIN", card_cryptogram_packet: "024242424242200504Jhf05ztWKDp2XAZhCkF1nbJGXPnKGx0KU3iZos2fYpL0tNoTLytJyOh0UviRJxKpkUslV7bdCUf+gUnCGajapuBg1a0cNqlRg22gCrVs0M64VCRW+KJjWwheA7tmyT3WnAhJNolBrLrLcr93xmlu0KHkYShpipp8dYEUYEdZ+WW8+XrFpJUuCP+YUCvVcQAQzwy9VP/yJWQO//g2bLDnUCWuYuldeqaK7+LwtHKMKgghraLFmJp1p+zTXicef9YBgzuJyLD86DKzowmkBUfTJNKMy1dVJbsITg2u2UR9YgBqMFunmhtHnBB8J28/qK2lqRMygQtO1Rf+4qGDJaXTvA=="}
      resp = JSON.parse(response.body)
      expect(resp["data"]["message"]).to eq("Подтверждение платежа")
      expect(resp["data"]["transaction_id"]).to_not eq(nil)
      expect(resp["data"]["pa_req"]).to_not eq(nil)
      expect(resp["data"]["acs_url"]).to_not eq(nil)
    end
  end

  describe "POST #accept_payment" do
    it "does not create card" do
      post :accept_payment, params: {MD: 123456, PaRes: "qwe123"}
      resp = JSON.parse(response.body)
      expect(resp["data"]["message"]).to eq("Транзакция не найдена")
      expect(resp["data"]["success"]).to eq(false)
    end
  end

  describe "DELETE #remove_card" do
    it "deletes user card" do
      card = Card.create!(last_four_numbers: "1234", token: "123", user_id: @auth_user.id, expiration_date: "05/20")
      expect {
        delete :remove_card, params: {id: @auth_user.id, card_id: card.id}
      }.to change(Card, :count).by(-1)
      resp = JSON.parse(response.body)
      expect(resp["data"]["status"]).to eq("OK")
    end

    it "does not delete user card" do
      card = Card.create!(last_four_numbers: "1234", token: "123", user_id: @user.id, expiration_date: "05/20")
      delete :remove_card, params: {id: @user.id, card_id: card.id}
      resp = JSON.parse(response.body)
      expect(resp["data"]["error"]).to eq("Card not found for this user")
    end
  end

  describe "GET #cards" do
    it "returns user bank cards" do
      card = Card.create!(last_four_numbers: "1234", token: "123", user_id: @auth_user.id, expiration_date: "05/20")
      get :cards, params: {id: @auth_user.id}
      resp = JSON.parse(response.body)
      expect(resp["data"]["cards"][0]["last_four_numbers"]).to eq("1234")
    end
  end

  describe "POST #close_debt" do
    it "closes user debt" do
      order = create(:order)
      order.update(user_id: @auth_user.id)
      post :close_debt, params: {id: @auth_user.id, card_id: @auth_user.cards[0].id}
      resp = JSON.parse(response.body)
      expect(resp["data"]["error"]["errors"]).to eq("Payment error")
    end
  end
end
