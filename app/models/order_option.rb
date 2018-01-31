# == Schema Information
#
# Table name: order_options
#
#  id          :integer          not null, primary key
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default("active")
#  price       :float
#

class OrderOption < ApplicationRecord
  validates :price, presence: true
  has_and_belongs_to_many :orders

  enum status: %i(active inactive)
end
