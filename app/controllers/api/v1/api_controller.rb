class Api::V1::ApiController < ActionController::API
  include CanCan::ControllerAdditions
  after_action :driver_activity, if: Proc.new { !current_driver.nil? }
  after_action :user_activity, if: Proc.new { !current_user.nil? }

  rescue_from CanCan::AccessDenied do |exception|
    current_client = current_user || current_driver
    if current_client
      if current_client.status == 'inactive'
        render json: { error: "Client is inactive" }, status: 410
      elsif current_driver && !current_driver.confirmed
        render json: { error: "Driver is unconfirmed" }, status: 403
      else
        render json: { error: "#{exception}"}, status: 401
      end
    else
      render json: { error: "Client not found" }, status: 406
    end
  end

  def current_ability
    @current_ability ||= current_user.nil? ? Ability::DriverAbility.new(current_driver) : Ability::UserAbility.new(current_user)
  end

  private

    def driver_activity
      @current_driver.try(:touch)
    end

    def user_activity
      @current_user.try(:touch)
    end

    def current_driver
      if driver_id_in_token?
        @current_driver ||= Driver.find(auth_token[0]['driver_id'])
      else
        nil
      end
    end

    def current_user
      if user_id_in_token?
        @current_user ||= User.find(auth_token[0]['user_id'])
      else
        nil
      end
    end

    def http_token
      @http_token ||= request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
    end

    def auth_token
      @auth_token ||= JsonWebToken.decode(http_token)
    end

    def user_id_in_token?
      http_token && auth_token && auth_token[0]['user_id']
    end

    def driver_id_in_token?
      http_token && auth_token && auth_token[0]['driver_id']
    end

    def parse_image_data(base64_image)
      filename = "upload-image"
      in_content_type, encoding, string = base64_image.split(/[:;,]/)[1..3]

      @tempfile = Tempfile.new(filename)
      @tempfile.binmode
      @tempfile.write Base64.decode64(string)
      @tempfile.rewind

      # content_type = `file --mime -b #{@tempfile.path}`.split(";")[0]

      # extension = content_type.match(/gif|jpeg|png/).to_s
      content_type = "png"
      extension = content_type

      filename += ".#{extension}" if extension

      ActionDispatch::Http::UploadedFile.new({
        tempfile: @tempfile,
        content_type: content_type,
        filename: filename
      })
    end

    def clean_tempfile
      if @tempfile
        @tempfile.close
        @tempfile.unlink
      end
    end
end
