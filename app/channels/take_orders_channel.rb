class TakeOrdersChannel < ApplicationCable::Channel
  def subscribed
    user = User.find(params[:data][:user_id])
    stream_for user
  end

  def receive(data)
    ActionCable.server.broadcast("take_orders", data)
  end
end
