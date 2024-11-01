# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Role::DEFAULT.values.each do |role_name|
  Role.find_or_create_by!(name: role_name)
end

admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.username = 'user_admin'
  user.password = Rails.application.credentials.admin_password.to_s
  user.password_confirmation = Rails.application.credentials.admin_password.to_s
end

admin_role = Role.find_by!(name: Role::DEFAULT[:admin])
admin.roles << admin_role unless admin.roles.include?(admin_role)
