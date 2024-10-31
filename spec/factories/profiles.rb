FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    country { Faker::Address.country_code }
    state { generate_state_for(country) }
    city { Faker::Address.city }
    association :user
  end
end

def generate_state_for(country_code)
  ISO3166::Country[country_code]&.subdivisions&.to_a&.sample[1]['code']
end