module ControllerMacros
  def login_user
    before(:each) do
      @auth_user = FactoryBot.create(:user)
      token = JsonWebToken.encode( { user_id: @auth_user.id } )
      request.headers.merge!(Authorization: "Bearer #{token}")
    end
  end

  def login_driver
    before(:each) do
      @auth_driver = FactoryBot.create(:driver)
      token = JsonWebToken.encode( { driver_id: @auth_driver.id } )
      request.headers.merge!(Authorization: "Bearer #{token}")
    end
  end
end
