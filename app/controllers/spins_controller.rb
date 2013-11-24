class SpinsController < ApplicationController
  
  respond_to :json

  def index
    if params[:game_id]
      game_ids = params[:game_id].scan(/^g(.+)/)
      unless game_ids.empty?
        @open_game = Game.find_by_game_id(game_ids.first)
      end
    end
    @highscores = Game.select("name, spins, finished").order('spins DESC, created_at ASC').limit(10)
  end

  def create
    game = Game.spin_by_game_id(params[:game_id])
    if game.name.nil? && !params[:name].nil?
      game.update_attributes(name: params[:name])
    end
    respond_to do |format|
      format.json { render json: { win: !game.finished?, score: game.score } }
    end
  end

  def update
    game = Game.find_by_game_id(params[:id])
    game.update_attributes!(name: params[:name])
    render nothing: true, status: 200
  end
end