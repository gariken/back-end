class PassSendingJob < ApplicationJob
  include HTTParty

  queue_as :default

  def perform(phone_number, user_password)
    login = Rails.application.secrets.sms[:login]
    password = Rails.application.secrets.sms[:password]
    message = "Code: #{user_password}"
    HTTParty.get("http://smsc.ru/sys/send.php?login=#{login}&psw=#{password}&phones=#{phone_number}&mes=#{message}")
  end
end
