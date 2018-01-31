class CancelOrdersForDriversChannel < ApplicationCable::Channel
  def subscribed
    driver = Driver.find(params[:data][:driver_id])
    stream_for driver
  end

  def receive(data)
    ActionCable.server.broadcast("cancel_orders", data)
  end
end
