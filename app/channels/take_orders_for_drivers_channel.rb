class TakeOrdersForDriversChannel < ApplicationCable::Channel
  def subscribed
    driver = Driver.find(params[:data][:driver_id])
    stream_for driver
  end

  def receive(data)
    ActionCable.server.broadcast("take_orders_for_drivers", data)
  end
end
