FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    sequence(:pseudo) { |n| "User#{n}" }
    description { "Description de l'utilisateur" }
    confirmed_at { Time.current }

    trait :with_games do
      after(:create) do |user|
        create_list(:game, 3, user: user)
      end
    end
  end
end
