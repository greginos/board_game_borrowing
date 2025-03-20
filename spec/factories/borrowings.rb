FactoryBot.define do
  factory :borrowing do
    user
    game
    start_date { Date.current }
    end_date { Date.current + 1.week }
  end
end
