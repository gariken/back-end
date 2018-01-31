class PushSendingJob < ApplicationJob
  include HTTParty

  queue_as :default

  def perform(topic, title, body)
    Firebase.send_message(topic, title, body)
  end
end
