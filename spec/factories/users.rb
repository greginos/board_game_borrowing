FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    sequence(:pseudo) { |n| "user#{n}" }
    confirmed_at { Time.current }

    trait :with_games do
      after(:create) do |user|
        create_list(:game, 3, user: user)
      end
    end
  end
end
