class Api::V1::SynchronizationController < Api::V1::ApiController
  load_and_authorize_resource
  def create
    consumer = current_user.nil? ? current_driver : current_user
    SynchronizationChannel.broadcast_to(
      consumer,
      data: params[:data]
    )
  end
end
