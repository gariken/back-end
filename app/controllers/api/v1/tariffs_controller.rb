class Api::V1::TariffsController < Api::V1::ApiController

  def index
    render json: { data: { tariffs: Tariff.where(status: 'active').order(position: 'asc') } }
  end
end
