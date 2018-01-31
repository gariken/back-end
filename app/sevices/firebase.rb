class Firebase
  include HTTParty

  FCM_URL = ENV.fetch("FCM_URL") { "https://fcm.googleapis.com/v1/projects/eskar-d0569/messages:send" }

  def self.send_message(topic, title, body)
    response = HTTParty.post(
      FCM_URL,
      body: { "message": { "topic": "#{topic}", "notification": { "body": "#{body}", "title": "#{title}" }, "android": { "notification": { "sound": "default" } } } }.to_json,
      headers: { 'Authorization': "Bearer #{FirebaseToken.new.generate_access_token['access_token']}",  'Content-Type': 'application/json' }
    )
  end
end
