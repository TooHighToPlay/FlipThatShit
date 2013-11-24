class Game < ActiveRecord::Base
  validates :game_id, presence: true, length: 0..100
  validates :name, length: 0..100, allow_blank: true

  def self.spin_by_game_id(game_id)
    game = Game.find_or_create_by!(game_id: game_id)
    return game if game.finished?
    game.spins += 1
    game.finished = rand(100) <= 25
    game.save
    game
  end

  def as_json(options={})
    result = super(options)
    result[:score] = self.score
    result
  end

  def score
    2 ** (self.spins - (self.finished? ? 1 : 0))
  end
end
