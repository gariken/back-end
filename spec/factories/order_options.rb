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

FactoryBot.define do
  factory :order_option do
    description "Option"
    price 100
  end
end
