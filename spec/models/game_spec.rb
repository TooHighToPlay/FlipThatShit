require 'spec_helper'

describe Game do

  let(:game) { FactoryGirl.create(:game) }
  
  describe 'game_id' do

    it { game.should be_valid }

    describe 'blank' do
      before { game.game_id = '  ' }
      it { game.should_not be_valid }
    end

    describe 'too long' do
      before { game.game_id = 'asdfe' * 20 + 'h' }
      it { game.should_not be_valid }
    end
  end

  describe 'name' do
    it { game.should be_valid }

    describe 'blank' do
      before { game.name = nil }
      it { game.should be_valid }
    end

    describe 'too long' do
      before { game.name = 'asdfe' * 20 + 'h' }
      it { game.should_not be_valid }
    end
  end

  describe '#score' do

    before do
      game.finished = false
      game.spins = 3
    end

    it { game.score.should == 8 } 

    describe 'finished' do
      before { game.finished = true }
      it { game.score.should == 4 }
    end
  end

  describe '#spin_by_game_id' do

    let(:id) { 'some id' }

    describe 'new id' do
      it do
        expect { Game.spin_by_game_id("new id") }
          .to change { Game.count }.by(1)
      end

      describe 'win' do
        let(:game) do
          srand(5) # rand(100) => 99
          Game.spin_by_game_id(id)
        end

        it { game.spins.should == 1 }
        it { game.finished.should == false }
        it { game.score.should == 2 }
      end

      describe 'lose' do
        let(:game) do
          srand(3) # rand(100) => 24
          Game.spin_by_game_id(id)
        end

        it { game.spins.should == 1 }
        it { game.finished.should == true }
        it { game.score.should == 1 }
      end
    end

    describe 'id exists' do

      describe 'win' do
        let!(:result) do
          game.update_attributes!(spins: 1)
          srand(5) # rand(100) => 99
          Game.spin_by_game_id(game.game_id)
        end

        it { game.reload.spins.should == 2 }
        it { game.reload.finished.should == false }
        it { game.reload.score.should == 4 }
      end

      describe 'lose' do
        let!(:result) do
          game.update_attributes!(spins: 1)
          srand(3) # rand(100) => 24
          Game.spin_by_game_id(game.game_id)
        end

        it { game.reload.spins.should == 2 }
        it { game.reload.finished.should == true }
        it { game.reload.score.should == 2 }
      end

    end

    describe 'game finished' do
      let!(:game) { FactoryGirl.create(:game, game_id: id, finished: true, spins: 4) }
      before { Game.spin_by_game_id(id) }
      it { game.reload.spins.should == 4 }
      it { game.reload.finished.should == true }
      it { game.reload.score.should == 8 }
    end

  end

end