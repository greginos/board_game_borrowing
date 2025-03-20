FactoryBot.define do
  factory :game do
    user
    board_game
    borrowable { false }
  end
end
