require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

  login_user

  before do
    @tariff1 = create(:tariff)
    @tariff2 = create(:tariff)
    if !("06:00"..."23:00").include?(Time.current.strftime("%H:%M"))
      @price = @tariff1.night_price_per_kilometer
    else
      @price = @tariff1.price_per_kilometer
    end
    @distance = Mapbox.distance(55.82173, 37.660269, 55.766101, 37.640075)[:distance_in_km].round(1)
  end

  describe "GET #index" do
    it "assigns the orders as @orders for user" do
      order = create(:order)
      order.update(user_id: User.all.last.id)
      get :index, params: {user_id: order.user_id}
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe "GET #show" do
    it "assigns the order as @order" do
      order = create(:order)
      get :show, params: {id: order.id}
      expect(assigns(:order)).to eq(order)
    end
  end

  describe "GET #preliminary" do
    it "returns the preliminary order as @preliminary order" do
      get :preliminary, params: {lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075}
      expect(assigns(:preliminary_order)[:distance]).to eq(8.2)
      expect(assigns(:preliminary_order)[:tariffs][0][:name]).to eq(@tariff1.name)
      expect(assigns(:preliminary_order)[:tariffs][1][:name]).to eq(@tariff2.name)
      expect(assigns(:preliminary_order)[:tariffs][0][:amount]).to eq((@price * @distance).round)
      expect(assigns(:preliminary_order)[:tariffs][1][:amount]).to eq((@price * @distance).round)
    end

    it "calculates the preliminary order with order options" do
      opt1 = create(:order_option)
      opt2 = create(:order_option)
      get :preliminary, params: {lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075, order_option_ids: [opt1.id, opt2.id]}
      expect(assigns(:preliminary_order)[:distance]).to eq(8.2)
      expect(assigns(:preliminary_order)[:tariffs][0][:name]).to eq(@tariff1.name)
      expect(assigns(:preliminary_order)[:tariffs][1][:name]).to eq(@tariff2.name)
      expect(assigns(:preliminary_order)[:tariffs][0][:amount]).to eq((@price * @distance).round + opt1.price + opt2.price)
      expect(assigns(:preliminary_order)[:tariffs][1][:amount]).to eq((@price * @distance).round + opt1.price + opt2.price)
    end
  end

  describe "POST #create" do
    it "creates a new order with cash" do
      user = create(:user)
      post :create, params: {card_id: 0, lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075, user_id: user.id, comment: "comment", tariff_id: @tariff1.id}
      expect(assigns(:order)[:user_phone]).to eq(user.phone_number)
      expect(assigns(:order)[:user_name]).to eq('Petya')
      expect(assigns(:order)['address_from']).to eq('Россия, Москва, улица Космонавтов, 15')
      expect(assigns(:order)['address_to']).to eq('Россия, Москва, Мясницкая улица, 38с1')
      expect(assigns(:order)['amount']).to eq((@price * @distance).round)
      order_id = assigns(:order)['id'].to_i
      payment = Payment.find_by(order_id: order_id)
      expect(payment.description).to eq("Оплата заказа №#{order_id}")
      expect(payment.payment_method).to eq("cash")
    end

    # it "creates a new order with cashless" do
    #   card = @auth_user.cards[0]
    #   post :create, params: {card_id: card.id, lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075, user_id: @auth_user.id, comment: "comment", tariff_id: @tariff1.id}
    #   puts response.body
    #   expect(assigns(:order)[:user_phone]).to eq(@auth_user.phone_number)
    #   order_id = assigns(:order)['id'].to_i
    #   payment = Payment.find_by(order_id: order_id)
    #   expect(payment.payment_method).to eq("cashless")
    #   expect(payment.card_id).to eq(card.id)
    # end

    it "creates a new order with order options" do
      user = create(:user)
      opt1 = create(:order_option)
      opt2 = create(:order_option)
      post :create, params: {card_id: 0, lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075, user_id: user.id, order_option_ids: [opt1.id, opt2.id], tariff_id: @tariff1.id}
      expect(assigns(:order)[:order_options][0][:id]).to eq(opt1.id)
      expect(assigns(:order)[:order_options][1][:id]).to eq(opt2.id)
      expect(assigns(:order)['amount']).to eq((@price * @distance).round + opt1.price + opt2.price)
    end
  end

  describe "PUT #estimate" do
    it "updates order rating" do
      order = create(:order)
      order.update(driver_id: create(:driver).id)
      put :estimate, params: {id: order.id, rating: 3, review: "review"}
      order.reload
      expect(order.rating).to eq(3)
      expect(order.review).to eq("review")
    end

    it "updates driver rating" do
      order = create(:order)
      driver = create(:driver)
      order.update(driver_id: driver.id)
      driver.update(rating: 4.33)
      30.times do
        create(:order).update(driver_id: driver.id, rating: 3)
      end
      80.times do
        create(:order).update(driver_id: driver.id, rating: 5)
      end
      40.times do
        create(:order).update(driver_id: driver.id, rating: 4)
      end
      20.times do
        create(:order).update(driver_id: driver.id)
      end
      put :estimate, params: {id: order.id, rating: 3}
      order.reload
      driver.reload
      expect(driver.rating).to eq(4.32)
      expect(order.rating).to eq(3)
    end

    it "updates driver points" do
      order = create(:order)
      driver = create(:driver)
      order.update(driver_id: driver.id)
      put :estimate, params: {id: order.id, rating: 5}
      order.reload
      driver.reload
      expect(driver.points).to eq(5)
      expect(driver.rating).to eq(5)
      expect(order.rating).to eq(5)
    end
  end

  describe "DELETE #destroy" do
    it "deletes opened order" do
      order = create(:order_with_tariff)
      expect {
        delete :destroy, params: {id: order.id}
      }.to change(Order, :count).by(-1)
    end
  end
end
