class Api::V1::OrderOptionsController < Api::V1::ApiController

  def index
    render json: { data: { order_options: OrderOption.where(status: 'active') } }
  end
end
