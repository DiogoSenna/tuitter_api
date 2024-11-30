class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 8, maximum: 128 },
            password: true,
            if: :password_required?

  has_one :profile
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :permissions
  has_many :tueets, dependent: :destroy

  def can?(*abilities)
    user_permissions = permissions + roles.flat_map(&:permissions)

    abilities.all? do |ability|
      resolved = Permissions.resolve_permission(ability)
      resolved = [resolved] unless resolved.is_a?(Array)

      resolved.all? { |permission| user_permissions.pluck(:name).include?(permission.to_s) }
    end
  end

  def cannot?(*abilities)
    not can?(*abilities)
  end

  private

  def password_required?
    new_record? || password.present?
  end
end