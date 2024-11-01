class CreateRolesUsersJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :roles, :users do |t|
      t.index [:role_id, :user_id], unique: true

      t.foreign_key :roles
      t.foreign_key :users
    end
  end
end
