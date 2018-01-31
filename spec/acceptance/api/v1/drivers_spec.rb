require 'acceptance_helper'

resource "Drivers", acceptance: true do
  before do
    @driver = create(:driver)
  end

  get "/api/v1/drivers/:id" do
    parameter :id, "Driver id"

    example "Get driver", document: :private do
      explanation "Get driver"

      token = JsonWebToken.encode( { driver_id: @driver.id } )
      header "Authorization", "Bearer #{token}"

      do_request({id: @driver.id})
      expect(status).to eq 200
    end
  end

  put "/api/v1/drivers/:id" do
    parameter :id, "Driver id"
    parameter :other, "name, surname, license, car_model, tariff_id, photo, licence_plate"

    example "Update driver", document: :private do
      explanation "Update driver"

      token = JsonWebToken.encode( { driver_id: @driver.id } )
      header "Authorization", "Bearer #{token}"

      do_request({id: @driver.id, surname: "Surname"})
      expect(status).to eq 200
    end
  end

  put "/api/v1/drivers/:id/remove_image" do
    parameter :id, "Driver id"
    parameter :photo, "Random value"
    parameter :license, "Random value"

    example "Remove driver photo/license", document: :private do
      explanation "Remove driver photo/license"

      token = JsonWebToken.encode( { driver_id: @driver.id } )
      header "Authorization", "Bearer #{token}"

      do_request({id: @driver.id, photo: "remove", license: "remove"})
      expect(status).to eq 200
    end
  end

  post "/api/v1/drivers/:id/initialization" do
    parameter :id, "Driver id"
    parameter :lat, "Driver current latitude"
    parameter :lon, "Driver current longitude"

    example "Initialize driver", document: :private do
      explanation "Initialize driver"

      token = JsonWebToken.encode( { driver_id: @driver.id } )
      header "Authorization", "Bearer #{token}"

      do_request({id: @driver.id, lat: 12.344312, lon: 15.231432})
      expect(status).to eq 200
    end
  end

  post "/api/v1/drivers/send_password" do
    parameter :phone_number, "Driver phone number"

    example "Send password for existing driver", document: :private do
      explanation "Send password for existing driver"

      do_request({phone_number: @driver.phone_number})
      expect(status).to eq 200
    end
  end

  post "/api/v1/drivers/send_password" do
    parameter :phone_number, "Driver phone number"

    example "Create driver and send password for new driver", document: :private do
      explanation "Create  driver and send  password for new driver"

      do_request({phone_number: '89041236745'})
      expect(status).to eq 200
    end
  end

  post "/api/v1/drivers/auth" do
    parameter :password, "Driver password"
    parameter :phone_number, "Driver phone number"

    example "Auth driver", document: :private do
      explanation "Auth driver"

      driver = create(:driver)
      do_request({phone_number: @driver.phone_number, password: @driver.password})
      expect(status).to eq 200
    end
  end
end
