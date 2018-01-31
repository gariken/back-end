# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  phone_number       :string           not null
#  encrypted_password :string           not null
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  sex                :integer
#  surname            :string
#  status             :integer          default("active")
#  favorite_addresses :string           default("")
#  photo              :string
#  email              :string
#
# Indexes
#
#  index_users_on_phone_number  (phone_number) UNIQUE
#

FactoryBot.define do
  factory :user do
    phone_number { rand_phone }
    password 'qwerty'
    name 'Petya'
    status 0
    photo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'images', 'photo.jpg'), 'image/jpg') }

    after(:create) do |user|
      card = Card.create!(last_four_numbers: "1234", token: "4DA7B4CA321F1D770C99ACF72987242099EF328DE31D30B5C8F894E0DDB04825", user_id: user.id, expiration_date: "05/20")
    end
  end
end

def rand_phone
  "#{Random.new.rand(10000000000..99999999999)}"
end
