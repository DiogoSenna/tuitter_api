class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 8, maximum: 128 },
            password: true,
            allow_nil: true, on: :update

  has_one :profile
end