class Mapbox
  include HTTParty

  ACCESS_TOKEN = Rails.application.secrets.mapbox[:access_token]

  def self.distance(lat_from, lon_from, lat_to, lon_to)
    begin
      response = HTTParty.get("https://api.mapbox.com/directions/v5/mapbox/driving/#{lon_from},#{lat_from};#{lon_to},#{lat_to}.json?access_token=#{ACCESS_TOKEN}")
      distance_in_km = JSON.parse(response.body)['routes'][0]['legs'][0]['distance']/1000
      { distance_in_km: distance_in_km }
    rescue Exception => e
      { error: "Invalid Mapbox response. Error: #{e}" }
    end
  end

  def self.duration(lat_from, lon_from, lat_to, lon_to)
    begin
      response = HTTParty.get("https://api.mapbox.com/directions/v5/mapbox/driving/#{lat_from},#{lon_from};#{lat_to},#{lon_to}.json?access_token=#{ACCESS_TOKEN}")
      duration_in_minutes = (JSON.parse(response.body)['routes'][0]['legs'][0]['duration'] / 60) % 60
      { duration_in_minutes: duration_in_minutes }
    rescue Exception => e
      { error: "Invalid Mapbox response. Error: #{e}" }
    end
  end

  def self.route(lat_from, lon_from, lat_to, lon_to)
    begin
      response = HTTParty.get("https://api.mapbox.com/directions/v5/mapbox/driving/#{lat_from},#{lon_from};#{lat_to},#{lon_to}?geometries=polyline&access_token=#{ACCESS_TOKEN}")
      route = JSON.parse(response.body)
      route
    rescue Exception => e
      { error: "Invalid Mapbox response. Error: #{e}", coordinates: [lat_from, lon_from, lat_to, lon_to] }
    end
  end
end
