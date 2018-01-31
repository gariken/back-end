class OrdersChannel < ApplicationCable::Channel
  def subscribed
    driver = Driver.find(params[:data][:driver_id])
    stream_for driver
  end

  def receive(data)
    ActionCable.server.broadcast("orders", data)
  end
end
