class UsersCommands::CloseDebt
  def initialize(user, card_id)
    @user = user
    @card_id = card_id
  end

  def execute
    if !@user.orders.blank?
      return { errors: 'Payment not found' } unless last_payment = @user.orders.last.payment
      if last_payment.status == 'not_paid'
        card = Card.find_by(id: @card_id.to_i, user_id: @user.id)
        if card
          payment = CloudPayments::Client.token_payment(last_payment.amount, last_payment.user_id, card.token)
          if payment[:code] == 0
            last_payment.update(status: 'paid', data: payment[:data])
            @user
          else
            { errors: { errors: 'Payment error', message: payment[:message] } }
          end
        else
          { errors: 'Card not found for this user' }
        end
      else
        { errors: "This user hasn't debt" }
      end
    else
      { errors: "This user hasn't orders" }
    end
  end

end
