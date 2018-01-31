class Api::V1::Drivers::AuthenticationController < Api::V1::ApiController
  def send_password
    render json: DriversCommands::FindOrCreate.new(params[:phone_number]).execute
  end

  def authenticate_driver
    phone_number = Phony.normalize(params[:phone_number].gsub(/[^0-9]/, "").gsub(/^8/, "7")) unless params[:phone_number].nil?

    driver = Driver.find_for_database_authentication(phone_number: phone_number)
    if driver && driver.valid_password?(params[:password])
      render json: payload(driver)
    else
      render json: { data: { error: "Invalid password" } }, status: :unauthorized
    end
  end

  private

  def payload(driver)
    {
      data: {
              auth_token: JsonWebToken.encode( { driver_id: driver.id } ),
              driver: driver
            }
    }
  end
end
