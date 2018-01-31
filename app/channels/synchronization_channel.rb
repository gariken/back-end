class SynchronizationChannel < ApplicationCable::Channel
  def subscribed
    consumer = params[:data][:user_id].nil? ? Driver.find(params[:data][:driver_id]) : User.find(params[:data][:user_id])
    stream_for consumer
  end

  def receive(data)
    ActionCable.server.broadcast("synchronization", data)
  end
end
