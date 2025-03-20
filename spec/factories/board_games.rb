FactoryBot.define do
  factory :board_game do
    sequence(:name) { |n| "Jeu de société #{n}" }
    sequence(:ean) { |n| "1234567890#{n}" }
    image_link { "https://example.com/image.jpg" }
    min_players { 2 }
    max_players { 4 }
    minimum_age { 8 }
    length { "30-60 min" }
    description { "Un jeu de société passionnant" }
  end
end
