class CloudPayments::Api
  include HTTParty

  CLOUD_PAUMENTS_URL = ENV.fetch("CLOUD_PAUMENTS_URL") { "https://api.cloudpayments.ru/" }
  PUBLIC_KEY = Rails.application.secrets.cloud_payments[:public_key]
  SECRET_KEY = Rails.application.secrets.cloud_payments[:secret_key]

  def self.cryptogram(params = {})
    base_request("payments/cards/charge", {
      Amount: params[:amount],
      Currency: params[:currency],
      IpAddress: params[:ip_address],
      Name: params[:name],
      CardCryptogramPacket: params[:card_cryptogram_packet],
      Description: params[:description],
      AccountId: params[:account_id]
    })
  end

  def self.post3ds(params = {})
    base_request("payments/cards/post3ds", {
      TransactionId: params[:transaction_id],
      PaRes: params[:pa_res]
    })
  end

  def self.refund(params = {})
    base_request("payments/refund", {
      TransactionId: params[:transaction_id],
      Amount: params[:amount]
    })
  end

  def self.token(params = {})
    base_request("payments/tokens/charge", {
      Amount: params[:amount],
      Currency: params[:currency],
      AccountId: params[:account_id],
      Token: params[:token]
    })
  end

  private

    def self.base_request(api_path, body = {})
      response = HTTParty.post(
        CLOUD_PAUMENTS_URL + api_path,
        basic_auth: {
          username: PUBLIC_KEY,
          password: SECRET_KEY
        },
        body: body.to_json,
        headers: { 'Content-Type' => 'application/json' },
      )
      JSON.parse(response.body, symbolize_names: true)
    end
end
