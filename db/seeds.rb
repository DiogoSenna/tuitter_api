# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Permissions::ALL.each do |permission_name|
  Permission.find_or_create_by!(name: permission_name.to_s)
end

Roles::ALL.each do |role_sym|
  role = Role.find_or_create_by!(name: role_sym.to_s)
  permissions = Roles.permissions(role_sym).map(&:to_s)
  permissions = Permission.where(name: permissions)

  permissions.each do |permission|
    role.permissions << permission unless role.permissions.include?(permission)
  end
end

admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.username = 'user_admin'
  user.password = Rails.application.credentials.admin_password.to_s
  user.password_confirmation = Rails.application.credentials.admin_password.to_s
end

unless admin.profile.present?
  admin.create_profile!({
    first_name: 'John',
    last_name: 'Smith',
    birth_date: '1995-05-21',
    country: 'BR',
    state: 'RJ',
    city: 'Rio de Janeiro',
    is_private: true
  })
end

admin_role = Role.find_by!(name: Roles::ADMIN.to_s)
admin.roles << admin_role unless admin.roles.include?(admin_role)
