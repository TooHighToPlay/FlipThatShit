# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    game_id "some id"
    name "some name"
    finished false
    spins 3
  end
end
