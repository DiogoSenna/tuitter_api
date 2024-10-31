class CreateRolesUsersJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :roles, :users
  end
end
