class UsersCoordinatesChannel < ApplicationCable::Channel
  def subscribed
    consumer = params[:data][:user_id].nil? ? Driver.find(params[:data][:driver_id]) : User.find(params[:data][:user_id])
    stream_for consumer
  end

  def receive(data)
    user = User.find(data['user_id'])
    user.coordinates = data['coordinates']
    Driver.where("updated_at > ?", 15.minutes.ago).each do |driver|
      UsersCoordinatesChannel.broadcast_to(
        driver,
        {
          users_coordinates: user.coordinates,
          id: user.id
        }
      )
    end
  end
end
