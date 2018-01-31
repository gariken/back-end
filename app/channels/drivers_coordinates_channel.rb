class DriversCoordinatesChannel < ApplicationCable::Channel
  def subscribed
    consumer = params[:data][:user_id].nil? ? Driver.find(params[:data][:driver_id]) : User.find(params[:data][:user_id])
    stream_for consumer
  end

  def receive(data)
    driver = Driver.find(data['driver_id'])
    driver.coordinates = data['coordinates']
    User.where("updated_at > ?", 15.minutes.ago).each do |user|
      DriversCoordinatesChannel.broadcast_to(
        user,
        {
          drivers_coordinates: driver.coordinates,
          id: driver.id
        }
      )
    end
  end
end
