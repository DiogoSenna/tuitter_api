class Permission < ApplicationRecord
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :users

  # enum VALUES: %i[
  #   users_list users_show users_create users_update users_delete
  #   profiles_show profiles_create profiles_update
  #   roles_list roles_show roles_create roles_update roles_delete
  #   permissions_list permissions_show
  # ]

  def has_role?(role)
    roles.include?(role)
  end
end
