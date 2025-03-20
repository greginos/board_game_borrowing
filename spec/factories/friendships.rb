FactoryBot.define do
  factory :friendship do
    user
    friend { create(:user) }
    status { "pending" }

    trait :accepted do
      status { "accepted" }
    end

    trait :rejected do
      status { "rejected" }
    end
  end
end
