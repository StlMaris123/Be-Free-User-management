# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  role                   :integer          default(0)
#  phone_number           :string
#  first_name             :string
#  last_name              :string
#  age                    :integer
#  status                 :boolean          default(TRUE)
#  gender                 :integer          default("female")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  access_token           :string
#  expires_at             :datetime
#  refresh_token          :string
#  session_id             :string
#  latitude               :float
#  longitude              :float
#  address                :string
#  nick_name              :string
#
class User < ApplicationRecord
  require 'ffaker'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, :omniauthable, :omniauth_providers => [:google_oauth2], jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  enum gender: [:female, :male, :transgender, :dont_wish_to_disclose]
  # validates :age, numericality: { greater_than: 0 }
  before_create :set_nick_name
  geocoded_by :address
  after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        first_name: data['first_name'],
        email: data['email'],
        password: Devise.friendly_token[0,20]
      )
    end
    user
  end

  private
  def set_nick_name
    self.nick_name = FFaker::Name.name
  end
end
