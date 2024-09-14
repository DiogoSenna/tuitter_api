class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :birth_date, null: false
      t.string :city
      t.string :country
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
