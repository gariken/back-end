class CloudPaymentsController < ApplicationController
  # rescue_from CloudPayments::Webhooks::HMACError, :handle_hmac_error
  before_action -> { CloudPayments.webhooks.validate_data!(payload, hmac_token) }

  def pay
    event = CloudPayments.webhooks.on_pay(payload)
    render json: { code: 0 }
  end

  def fail
    event = CloudPayments.webhooks.on_fail(payload)
    render json: { code: 0 }
  end

  def recurrent
    event = CloudPayments.webhooks.on_recurrent(payload)
    render json: { code: 0 }
  end
end
