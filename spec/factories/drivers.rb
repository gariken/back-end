# == Schema Information
#
# Table name: drivers
#
#  id                 :integer          not null, primary key
#  phone_number       :string           not null
#  encrypted_password :string           not null
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  licence_plate      :string
#  photo              :string
#  car_model          :string
#  surname            :string
#  balance            :float
#  license            :string
#  points             :integer
#  confirmed          :boolean          default(FALSE)
#  rating             :float
#  status             :integer          default("active")
#  bonus_on_this_week :boolean          default(FALSE)
#  tariff_id          :integer
#  car_color          :string
#
# Indexes
#
#  index_drivers_on_phone_number  (phone_number) UNIQUE
#  index_drivers_on_tariff_id     (tariff_id)
#
# Foreign Keys
#
#  fk_rails_...  (tariff_id => tariffs.id)
#

FactoryBot.define do
  factory :driver do
    phone_number { rand_phone }
    password 'qwerty'
    name 'Vasya'
    surname 'bang'
    confirmed true
    points 0
    balance 150
    rating 0
    status 0
    photo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'images', 'photo.jpg'), 'image/jpg') }
    license { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'images', 'photo.jpg'), 'image/jpg') }
    after(:create) do |driver|
      driver.tariff = create(:tariff)
      driver.save
    end
  end
end

def rand_phone
  "#{Random.new.rand(10000000000..99999999999)}"
end
