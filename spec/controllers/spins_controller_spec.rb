require 'spec_helper'

describe SpinsController do
  describe '#index' do
    before { get :index }
    it { response.should be_success }
  end

  describe '#create' do
    
    let(:game_id) { 'some random hash' }
    let(:game) { Game.new(game_id: game_id, spins: 3, finished: false) }
    
    before do
      Game.should receive(:spin_by_game_id).with(game_id).and_return(game)
      post :create, game_id: game_id, format: :json
    end
    
    it { response.should be_success }

    let(:resp) { JSON.parse(response.body) }
    it { resp['win'].should == !game.finished? }
    it { resp['score'].should == game.score }

  end

  describe '#update' do
    let(:game_id) { 'some random hash' }
    let(:name) { 'John' }
    let!(:game) { FactoryGirl.create(:game, game_id: game_id, spins: 3, finished: true) }
    before { put :update, id: game_id, name: name }
    it { response.should be_success }
    it { game.reload.name.should == name }
  end
end