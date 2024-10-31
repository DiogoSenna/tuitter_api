class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 8, maximum: 128 },
            password: true,
            if: :password_required?

  has_one :profile

  private

  def password_required?
    new_record? || password.present?
  end
end