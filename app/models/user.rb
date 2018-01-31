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

class User < ApplicationRecord
  mount_uploader :photo, ImageUploader

  validates :phone_number, :encrypted_password, presence: true
  validates :phone_number, uniqueness: true
  validates :phone_number, length: { is: 11 }

  devise :database_authenticatable

  has_many :orders
  has_many :addresses
  has_many :payments, dependent: :destroy
  has_many :cards, dependent: :destroy

  enum sex: %i(male female)
  enum status: %i(active inactive)

  def coordinates=(coordinates)
    Redis.current.set("#{self.id}_user_coordinates", coordinates.to_json)
  end

  def coordinates
    JSON.parse(Redis.current.get("#{self.id}_user_coordinates")).map { |coordinate| coordinate.to_f }
  end

  def self.send_push_about_taking(order)
    driver = order.driver
    PushSendingJob.perform_later(
      "orders_users_#{order.id}",
      "Водитель откликнулся",
      "Эскархо #{driver.name} откликнулся на ваш заказ. #{driver.car_color} #{driver.car_model} с номером #{driver.licence_plate} скоро будет в точке отправления."
    )
  end

  def self.send_push_about_coming(order)
    driver = order.driver
    PushSendingJob.perform_later(
      "orders_users_#{order.id}",
      "Водитель прибыл",
      "#{driver.car_color} #{driver.car_model} #{driver.licence_plate} ожидает Вас в точке отправления."
    )
  end
end
