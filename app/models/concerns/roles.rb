module Roles
  ADMIN = :administrator.freeze
  REGULAR_USER = :regular_user.freeze
  PREMIUM_USER = :premium_user.freeze

  ALL = [ADMIN, REGULAR_USER, PREMIUM_USER].freeze

  def self.permissions(role)
    case role
    when ADMIN
      Permissions::ALL
    when REGULAR_USER
      Permissions::PROFILES
    when PREMIUM_USER
      Permissions::PROFILES + Permissions::TUEETS.take(1)
    else
      []
    end
  end
end