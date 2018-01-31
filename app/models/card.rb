# == Schema Information
#
# Table name: cards
#
#  id                  :integer          not null, primary key
#  last_four_numbers   :string           not null
#  token               :string           not null
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  expiration_date     :string           not null
#  card_type           :string
#  card_type_code      :integer
#  issuer              :string
#  issuer_bank_country :string
#
# Indexes
#
#  index_cards_on_user_id  (user_id)
#

class Card < ApplicationRecord
  validates :last_four_numbers, :token, :user_id, :expiration_date, presence: true

  belongs_to :user
end
