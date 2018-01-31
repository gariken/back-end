require 'acceptance_helper'

resource "Orders for drivers", acceptance: true do
  before do
    @driver = create(:driver)
    @order = create(:order_with_tariff)
    @order.update(driver_id: @driver.id)
    opt1 = create(:order_option)
    opt2 = create(:order_option)
    @order.order_option_ids = [opt1.id, opt2.id]
    token = JsonWebToken.encode( { driver_id: @driver.id } )
    header "Authorization", "Bearer #{token}"
  end

  get "/api/v1/orders" do
    example "Getting all new orders", document: :private do
      explanation "Getting all new orders"

      do_request()
      expect(status).to eq 200
    end
  end

  get "/api/v1/orders" do
    example "Getting all orders of driver", document: :private do
      explanation "Getting all orders of driver"

      @order.update(driver_id: @driver.id)

      do_request({driver_id: @driver.id})
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

  put "/api/v1/orders/:id/close" do
    parameter :id, "Order id"
    parameter :payed, "true or false, null will convert to true for old versions"

    example "Closing an order", document: :private do
      explanation "Closing an order"

      do_request({id: @order.id, payed: true})
      expect(status).to eq 200
    end
  end

  put "/api/v1/orders/:id/take" do
    parameter :id, "Order id"
    parameter :driver_id, "Driver id"

    example "Taking an order", document: :private do
      explanation "Taking an order"

      driver = create(:driver)
      order = create(:order_with_tariff)
      do_request({id: order.id, driver_id: driver.id})
      expect(status).to eq 200
    end
  end

  put "/api/v1/orders/:id/wait" do
    parameter :id, "Order id"

    example "Start waiting", document: :private do
      explanation "Start waiting"

      do_request({id: @order.id})
      expect(status).to eq 200
    end
  end

  put "/api/v1/orders/:id/start" do
    parameter :id, "Order id"

    example "Start driving", document: :private do
      explanation "Start driving"

      do_request({id: @order.id})
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
end
