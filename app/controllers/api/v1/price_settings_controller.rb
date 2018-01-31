class Api::V1::PriceSettingsController < Api::V1::ApiController
  def show
    render json: { data: { price_setting: PriceSetting.instance } }
  end
end
