FactoryBot.define do
  factory :tueet do
    content { Faker::Lorem.paragraph_by_chars(number: 280) }
    parent_id { nil }
    association :user, factory: :user
  end
end
