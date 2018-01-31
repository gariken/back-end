class Api::V1::Users::AuthenticationController < Api::V1::ApiController
  def send_password
    render json: UsersCommands::FindOrCreate.new(params[:phone_number]).execute
  end

  def authenticate_user
    phone_number = Phony.normalize(params[:phone_number].gsub(/[^0-9]/, "").gsub(/^8/, "7")) unless params[:phone_number].nil?

    user = User.find_for_database_authentication(phone_number: phone_number)
    if user && user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: { data: { error: "Invalid password" } }, status: :unauthorized
    end
  end

  private

  def payload(user)
    {
      data: {
              auth_token: JsonWebToken.encode({ user_id: user.id }),
              user: user
            }
    }
  end
end
