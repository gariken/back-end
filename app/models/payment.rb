# == Schema Information
#
# Table name: payments
#
#  id             :integer          not null, primary key
#  description    :string
#  amount         :float
#  data           :jsonb
#  user_id        :integer
#  order_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :integer          default("not_paid")
#  card_id        :integer
#  payment_method :integer
#
# Indexes
#
#  index_payments_on_order_id  (order_id)
#  index_payments_on_user_id   (user_id)
#

class Payment < ApplicationRecord
  validates :amount, :user_id, :order_id, :payment_method, presence: true

  belongs_to :user, optional: true
  belongs_to :order,  optional: true

  enum status: %i(not_paid paid)
  enum payment_method: %i(cash cashless)

  def pay_order
    if self.payment_method == 'cash'
      self.update(status: 'paid')
    else self.payment_method == 'cashless'
      card = Card.find(card_id)
      payment = CloudPayments::Client.token_payment(self.amount, self.user_id, card.token)
      if payment[:code] == 0
        self.update(status: 'paid', data: payment[:data])
      else
        return { errors: 'Payment error', message: payment[:message] }
      end
    end
    self
  end
end
