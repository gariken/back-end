class Api::V1::DriversController < Api::V1::ApiController
  before_action :set_driver, only: [:update, :show, :initialization, :remove_image]
  load_and_authorize_resource

  def initialization
    @driver.coordinates = [params[:lat].to_f, params[:lon].to_f]
    render json:
    {
      data:
          {
            tariffs: Tariff.where(status: 'active').order(position: 'asc'),
            driver: @driver,
            open_order: Order.where(driver_id: @driver.id, status: 'opened').last
          }
    }
  end

  def show
    render json: { data: { open_order: @driver.orders.where(status: 'opened').last, driver: @driver } }
  end

  def update
    @driver = DriversCommands::Update.new(@driver, driver_params).execute
    if @driver[:errors].nil?
      render json: { data: { driver: @driver } }
    else
      render json: { data: { error: @driver[:errors] } }, status: :unprocessable_entity
    end
  end

  def remove_image
    unless params[:photo].nil?
      @driver.remove_photo!
      @driver.save
    end
    unless params[:license].nil?
      @driver.remove_license!
      @driver.save
    end
    render json: { data: { driver: @driver } }
  end

  private
    def set_driver
      @driver = Driver.includes(:orders).find(params[:id])
    end

    def driver_params
      the_params = params.permit(:name, :surname, :photo, :car_model, :tariff_id, :license, :licence_plate, :car_color)
      the_params[:surname] = params[:surname].capitalize unless params[:surname].nil?
      the_params[:name] = params[:name].capitalize unless params[:name].nil?
      the_params[:photo] = parse_image_data(params[:photo]) if params[:photo].class.to_s == "String"
      the_params[:license] = parse_image_data(params[:license]) if params[:license].class.to_s == "String"
      the_params
    end
end
