class GoogleMaps
  include HTTParty

  API_KEY = Rails.application.secrets.google_maps[:key]

  def self.autocomplete(input, location="")
    begin
      response = HTTParty.get(Addressable::URI.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=#{input}&location=#{location}&language=ru&components=country:ru&key=#{API_KEY}").normalize)
      result = JSON.parse(response.body)
      { result: result }
    rescue Exception => e
      { error: "Invalid GoogleMaps response. Error: #{e}" }
    end
  end
end
