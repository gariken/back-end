class CloudPayments::Client
  def self.bind_card(name, ip, card_cryptogram_packet, user_id)
    transaction = CloudPayments::Api.cryptogram(
      amount: 1,
      currency: 'RUB',
      description: 'Привязка карты',
      ip_address: ip,
      name: name,
      account_id: user_id,
      card_cryptogram_packet: card_cryptogram_packet
    )

    if transaction[:Model]
      if transaction[:Model][:ReasonCode] == nil
        transaction = transaction[:Model]
        {
          message: "Подтверждение платежа",
          transaction_id: transaction[:TransactionId],
          pa_req: transaction[:PaReq],
          acs_url: transaction[:AcsUrl],
          term_url: ENV["ASSET_HOST"] + "api/v1/users/accept_payment"
        }
      else
        create_card(transaction)
      end
    else
      { message: transaction[:Message], success: transaction[:Success] }
    end
  end

  def self.accept_payment(transaction_id, pa_res)
    transaction = CloudPayments::Api.post3ds(
      transaction_id: transaction_id,
      pa_res: pa_res
    )

    create_card(transaction)
  end

  def self.token_payment(amount, user_id, token)
    transaction = CloudPayments::Api.token(
      amount: amount,
      currency: 'RUB',
      account_id: user_id,
      token: token
    )

    create_payment(transaction)
  end

  def self.check_card(user_id, token)
    transaction = CloudPayments::Api.token(
      amount: 1,
      currency: 'RUB',
      account_id: user_id,
      token: token
    )

    check(transaction)
  end

  private

    def self.create_card(transaction)
      if transaction[:Model]
        transaction = transaction[:Model]
        if transaction[:ReasonCode] == 0
          CloudPayments::Api.refund(amount: 1, transaction_id: transaction[:TransactionId])
          Card.create!(
            token: transaction[:Token],
            last_four_numbers: transaction[:CardLastFour],
            expiration_date: transaction[:CardExpDate],
            user_id: transaction[:AccountId],
            card_type: transaction[:CardType],
            card_type_code: transaction[:CardTypeCode],
            issuer: transaction[:Issuer],
            issuer_bank_country: transaction[:IssuerBankCountry]
          )
        end
        { message: transaction[:CardHolderMessage], code: transaction[:ReasonCode] }
      else
        { message: transaction[:Message], success: transaction[:Success] }
      end
    end

    def self.create_payment(transaction)
      if transaction[:Model]
        transaction = transaction[:Model]
        if transaction[:ReasonCode] == 0
          { message: transaction[:CardHolderMessage], code: transaction[:ReasonCode], data: transaction }
        end
        { message: transaction[:CardHolderMessage], code: transaction[:ReasonCode] }
      else
        { message: transaction[:Message], success: transaction[:Success] }
      end
    end

    def self.check(transaction)
      if transaction[:Model]
        transaction = transaction[:Model]
        if transaction[:ReasonCode] == 0
          CloudPayments::Api.refund(amount: 1, transaction_id: transaction[:TransactionId])
        end
        { message: transaction[:CardHolderMessage], code: transaction[:ReasonCode] }
      else
        { message: transaction[:Message], success: transaction[:Success] }
      end
    end
end
