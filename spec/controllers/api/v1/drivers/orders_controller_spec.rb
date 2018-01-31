require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

  login_driver

  describe "GET #index" do
    it "assigns the orders as @orders" do
      order = create(:order_with_tariff)
      opt = create(:order_option)
      order.order_options << opt
      get :index, params: {id: order.id}
      expect(assigns(:orders)).to eq([order])
    end

    it "assigns the orders as @orders by driver_id" do
      order = create(:order_with_tariff)
      order.update(driver_id: create(:driver).id)
      get :index, params: {id: order.id, driver_id: order.driver.id}
      expect(assigns(:orders)).to include order
    end
  end

  describe "GET #show" do
    it "assigns the order as @order" do
      order = create(:order_with_tariff)
      get :show, params: {id: order.id}
      expect(assigns(:order)).to eq(order)
    end
  end

  describe "PUT #close" do
    it "closes an order" do
      order = create(:order_with_tariff)
      order.update(driver_id: create(:driver).id)
      put :close, params: {id: order.id, waiting_minutes: 15}
      order.reload
      expect(order.status).to eq('closed')
    end

    it "updates order amount by waiting minutes" do
      order = create(:order_with_tariff)
      order.update(driver_id: create(:driver).id, waiting_minutes: 30)
      put :close, params: {id: order.id}
      order.reload
      expect(order.waiting_minutes).to eq(30)
      expect(order.amount).to eq(150 + (20 * 15))
    end

    it "does not update order amount by waiting minutes if waiting_minutes < free_waiting_minutes" do
      order = create(:order_with_tariff)
      order.update(driver_id: create(:driver).id, waiting_minutes: 6)
      put :close, params: {id: order.id}
      order.reload
      expect(order.waiting_minutes).to eq(6)
      expect(order.amount).to eq(150)
    end

    it "update driver points for order closing" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      order.update(driver_id: driver.id)
      put :close, params: {id: order.id, waiting_minutes: 6}
      order.reload
      driver.reload
      expect(driver.points).to eq(10)
    end

    it "update driver points for order distance > 10" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      order.update(driver_id: driver.id, distance: 11)
      put :close, params: {id: order.id, waiting_minutes: 6}
      order.reload
      driver.reload
      expect(driver.points).to eq(15)
    end

    it "update driver interest rate each 200 orders" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      199.times do |i|
        create(:order).update(driver_id: driver.id)
      end
      order.update(driver_id: driver.id)
      driver.update(created_at: DateTime.current + 3.month)
      put :close, params: {id: order.id, waiting_minutes: 6}
      order.reload
      driver.reload
      expect(driver.balance).to eq(78)
    end

    it "update driver interest rate by rating" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      100.times do |i|
        create(:order).update(driver_id: driver.id)
      end
      driver.update(rating: 4.9, created_at: DateTime.current + 3.month)
      order.update(driver_id: driver.id)
      put :close, params: {id: order.id, waiting_minutes: 6}
      order.reload
      driver.reload
      expect(driver.balance).to eq(78)
    end

    it "update driver balance" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      order.update(driver_id: driver.id)
      driver.update(created_at: DateTime.current + 3.month)
      put :close, params: {id: order.id, waiting_minutes: 6}
      order.reload
      driver.reload
      expect(driver.balance).to eq(76.5)
    end

    it "does not update driver balance in first month" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      order.update(driver_id: driver.id)
      put :close, params: {id: order.id, waiting_minutes: 6}
      order.reload
      driver.reload
      expect(driver.balance).to eq(150)
    end

    it "update driver points for distance" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      order.update(driver_id: driver.id, distance: 50)
      put :close, params: {id: order.id, waiting_minutes: 6}
      order.reload
      driver.reload
      expect(driver.points).to eq(35)
    end
  end

  describe "PUT #take" do
    it "sets driver" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      put :take, params: {id: order.id, driver_id: driver.id}
      order.reload
      expect(order.driver_id).to eq(driver.id)
      expect(order.time_of_taking).not_to eq(nil)
    end

    it "return error" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      driver.update(balance: 0)
      put :take, params: {id: order.id, driver_id: driver.id}
      resp = JSON.parse(response.body)
      expect(resp['data']['error']).to eq("Driver balance must be greater than 0")
    end
  end

  describe "PUT #start" do
    it "start driving" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      order.update(driver_id: driver.id)
      put :start, params: {id: order.id}
      order.reload
      expect(order.time_of_starting).not_to eq(nil)
    end
  end

  describe "PUT #wait" do
    it "start waiting" do
      order = create(:order_with_tariff)
      driver = create(:driver)
      order.update(driver_id: driver.id)
      put :wait, params: {id: order.id}
      order.reload
      expect(order.start_waiting_time).not_to eq(nil)
    end
  end
end
