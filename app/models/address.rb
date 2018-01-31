# == Schema Information
#
# Table name: addresses
#
#  id      :integer          not null, primary key
#  name    :string
#  body    :string
#  user_id :integer
#
# Indexes
#
#  index_addresses_on_user_id  (user_id)
#

class Address < ApplicationRecord
  belongs_to :user, optional: true
end
