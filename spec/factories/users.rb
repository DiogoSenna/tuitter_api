FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password(special_characters: true) }
  end
end