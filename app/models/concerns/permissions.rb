module Permissions
  USERS = %i[users_update users_delete].freeze
  PROFILES = %i[profiles_show profiles_update].freeze
  ROLES = %i[roles_index roles_show roles_create roles_update roles_delete].freeze
  TUEETS = %i[tueets_update].freeze

  ALL = USERS + PROFILES + ROLES + TUEETS

  def self.resolve_permission(permission)
    dynamic_alias = resolve_alias(permission)

    return dynamic_alias unless dynamic_alias.nil?

    permission
  end

  private

  def self.resolve_alias(name)
    case name.to_s
    when /_read\z/
      base_name = name.to_s.sub(/_read\z/, '')
      ALL.select { |permission| permission.to_s.match?(/\A#{base_name}_(index|show)\z/) }
    when /_write\z/
      base_name = name.to_s.sub(/_write\z/, '')
      ALL.select { |permission| permission.to_s.match?(/\A#{base_name}_(create|update)\z/) }
    when /_manage\z/
      base_name = name.to_s.sub(/_manage\z/, '')
      ALL.select { |permission| permission.to_s.match?(/\A#{base_name}_(index|show|create|update|delete)\z/) }
    else
      nil
    end
  end
end