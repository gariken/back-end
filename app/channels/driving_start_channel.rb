class DrivingStartChannel < ApplicationCable::Channel
  def subscribed
    user = User.find(params[:data][:user_id])
    stream_for user
  end

  def receive(data)
    ActionCable.server.broadcast("waiting_start", data)
  end
end
