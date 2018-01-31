class CancelOrdersForUsersChannel < ApplicationCable::Channel
  def subscribed
    user = User.find(params[:data][:user_id])
    stream_for user
  end

  def receive(data)
    ActionCable.server.broadcast("cancel_orders_for_users", data)
  end
end
