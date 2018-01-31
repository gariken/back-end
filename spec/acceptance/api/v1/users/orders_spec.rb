require 'acceptance_helper'

resource "Orders for users", acceptance: true do
  before do
    @driver = create(:driver)
    @user = create(:user)
    @order = create(:order)
    @order.update(driver_id: @driver.id)
    opt1 = create(:order_option)
    opt2 = create(:order_option)
    @order.order_option_ids = [opt1.id, opt2.id]
    token = JsonWebToken.encode( { user_id: @user.id } )
    header "Authorization", "Bearer #{token}"
  end

  get "/api/v1/orders" do
    parameter :user_id, "User id"

    example "Getting all orders of user", document: :private do
      explanation "Getting all orders of user"

      @order.update(user_id: @user.id)
      do_request({user_id: @user.id})
      expect(status).to eq 200
    end
  end

  get "/api/v1/orders/:id" do
    parameter :id, "Order id"

    example "Getting an order", document: :private do
      explanation "Getting an order"

      do_request({id: @order.id})
      expect(status).to eq 200
    end
  end

  get "/api/v1/orders/preliminary" do
    parameter :lat_from, "latitude(decimal)"
    parameter :lon_from, "longitude(decimal)"
    parameter :lat_to, "latitude(decimal)"
    parameter :lon_to, "longitude(decimal)"
    parameter :order_option_ids, "order option ids, if they exist"
    example "Getting an preliminary order", document: :private do
      explanation "Getting an preliminary order"

      do_request({lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075})
      expect(status).to eq 200
    end

    example "Getting an preliminary order with order options", document: :private do
      explanation "Getting an preliminary order with order options"

      opt1 = create(:order_option)
      opt2 = create(:order_option)
      do_request({lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075, order_option_ids: [opt1.id, opt2.id]})
      expect(status).to eq 200
    end
  end

  put "api/v1/orders/:id/estimate" do
    parameter :id, "Order id"
    parameter :rating, "Order rating (1-5)"
    parameter :review, "Order review"

    example "Set order rating", document: :private do
      explanation "Set order rating"

      do_request({id: @order.id, rating: 4, review: "Отличная поездка"})
      expect(status).to eq 200
    end
  end

  delete "api/v1/orders/:id" do
    parameter :id, "Order id"

    example "Delete order", document: :private do
      explanation "Delete order"

      do_request({id: @order.id})
      expect(status).to eq 200
    end
  end

  post "/api/v1/orders" do
    parameter :lat_from, "latitude(decimal)"
    parameter :lon_from, "longitude(decimal)"
    parameter :lat_to, "latitude(decimal)"
    parameter :lon_to, "longitude(decimal)"
    parameter :user_id, "User id"
    parameter :comment, "Order comment"
    parameter :tariff_id, "Tariff id"
    parameter :card_id, "card if or 0 for cash"
    parameter :order_option_ids, "Options ids"
    parameter :card_id, "0 for cash, null will convert to cash"

    example "Creating an order", document: :private do
      explanation "Creating an order"

      tariff = create(:tariff)
      @user.coordinates = [55.82173, 55.766101]
      @driver.coordinates = [55.82173, 55.766101]
      opt1 = create(:order_option)
      opt2 = create(:order_option)
      do_request({card_id: 0, lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075, user_id: @user.id, comment: "Как можно быстрее!", tariff_id: tariff.id, order_option_ids: [opt1.id, opt2.id]})
      expect(status).to eq 200
    end
  end
end
