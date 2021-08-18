require 'rails_helper'

RSpec.describe Game, type: :model do
	context 'with sufficient cards' do
		before :each do
			Card.create! image: 'card_1', name: 'Card 1'
			Card.create! image: 'card_2', name: 'Card 2'
			Card.create! image: 'card_3', name: 'Card 3'
			Card.create! image: 'card_4', name: 'Card 4'
			Card.create! image: 'card_5', name: 'Card 5'
			Card.create! image: 'card_6', name: 'Card 6'
			Card.create! image: 'card_7', name: 'Card 7'
			Card.create! image: 'card_8', name: 'Card 8'			
		end

		it 'must have rows' do
			game = Game.new rows: nil
			expect(game).not_to be_valid
			expect(game.errors).to have_key :rows
			expect(game.errors[:rows]).to include("can't be blank")

			game = Game.new rows: 1
			expect(game).not_to be_valid
			expect(game.errors).to have_key :rows
			expect(game.errors[:rows]).to include('must be greater than 1')
		end

		it 'must have columns' do
			game = Game.new columns: nil
			expect(game).not_to be_valid
			expect(game.errors).to have_key :columns
			expect(game.errors[:columns]).to include("can't be blank")

			game = Game.new columns: 1
			expect(game).not_to be_valid
			expect(game.errors).to have_key :columns
			expect(game.errors[:columns]).to include('must be greater than 1')
		end
		
		it 'must have valid group size' do
			game = Game.new group_size: nil
			expect(game).not_to be_valid
			expect(game.errors).to have_key :group_size
			expect(game.errors[:group_size]).to include("can't be blank")

			game = Game.new rows: 4, columns: 4, group_size: 3
			expect(game).not_to be_valid
			expect(game.errors).to have_key :group_size
			expect(game.errors[:group_size]).to include('must evenly divide game size')
		end

		it 'is valid with all valid attributes' do
			game = Game.new rows: 4, columns: 4, group_size: 2
			expect(game).to be_valid
		end

		context 'when complete' do
			let!(:game) { Game.create! rows: 2, columns: 2, group_size: 2 }
			let!(:card_a) { Card.create! image: 'card_a.jpg', name: 'Card A' }
			let!(:card_b) { Card.create! image: 'card_b.jpg', name: 'Card B' }

			it 'is valid with cards assigned to correct positions and with consistently solved pairs' do
				GameCard.create! game: game, card: card_a, position: 1, solved: false
				GameCard.create! game: game, card: card_b, position: 2, solved: true
				GameCard.create! game: game, card: card_a, position: 3, solved: false
				GameCard.create! game: game, card: card_b, position: 4, solved: true

				expect(game).to be_valid

				game.update complete: true

				expect(game).to be_valid
			end

			it 'must have cards assigned to expected positions' do
				GameCard.create! game: game, card: card_a, position: 1, solved: false
				GameCard.create! game: game, card: card_b, position: 2, solved: true
				GameCard.create! game: game, card: card_a, position: 3, solved: false
				GameCard.create! game: game, card: card_b, position: 5, solved: true
				game.update complete: true

				expect(game).not_to be_valid
				expect(game.errors).to have_key :cards
				expect(game.errors[:cards]).to include('do not include position 4')
				expect(game.errors[:cards]).to include('include unexpected position 5')
			end

			it 'must have consistently solved pairs of cards' do
				GameCard.create! game: game, card: card_a, position: 1, solved: false
				GameCard.create! game: game, card: card_b, position: 2, solved: true
				GameCard.create! game: game, card: card_a, position: 3, solved: true
				GameCard.create! game: game, card: card_b, position: 5, solved: false
				game.update complete: true

				expect(game).not_to be_valid
				expect(game.errors).to have_key :cards
				expect(game.errors[:cards]).to include('of name Card A must be either all solved or all unsolved')
				expect(game.errors[:cards]).to include('of name Card B must be either all solved or all unsolved')
			end
		end

		describe 'populate_cards' do
			let(:game) { Game.create rows: 4, columns: 6, group_size: 3 }
			it 'creates a valid complete game' do
				expect { game.populate_cards! }.not_to raise_error
				expect(game).to be_complete
				expect(game).to be_valid 
			end
			it 'assigns cards of correct group sizes' do
				expect { game.populate_cards! }.not_to raise_error
				game.cards.each do |card|
					expect(game.game_cards.where(card: card).count).to eq game.group_size
				end
			end
		end

		describe 'position_at' do
			it 'calculates 1-indexed position based on 1-indexed rows and columns' do
				game = Game.new rows: 4, columns: 4, group_size: 2
				expect(game.position_at 1, 1).to eq 1
				expect(game.position_at 1, 4).to eq 4
				expect(game.position_at 2, 1).to eq 5
				expect(game.position_at 4, 1).to eq 13
				expect(game.position_at 4, 4).to eq 16
			end
			it 'rejects invalid rows and columns' do
				game = Game.new rows: 2, columns: 2, group_size: 2
				expect { game.position_at 0, 1 }.to raise_error ArgumentError, 'Row out of range'
				expect { game.position_at 1, 0 }.to raise_error ArgumentError, 'Column out of range'
				expect { game.position_at 3, 1 }.to raise_error ArgumentError, 'Row out of range'
				expect { game.position_at 1, 3 }.to raise_error ArgumentError, 'Column out of range'
			end
		end
	end

	context 'with insufficient cards' do
		it 'fails validation even with valid attributes' do
			game = Game.new rows: 10, columns: 10, group_size: 2
			expect(game).not_to be_valid
			expect(game.errors).to have_key :size
			expect(game.errors[:size]).to include('cannot be greater than 0 as there are currently only 0 unique cards')

			Card.create! image: 'card_a.jpg', name: 'Card A'
			Card.create! image: 'card_b.jpg', name: 'Card B'
			game = Game.new rows: 3, columns: 4, group_size: 3
			expect(game).not_to be_valid
			expect(game.errors).to have_key :size
			expect(game.errors[:size]).to include('cannot be greater than 6 as there are currently only 2 unique cards')
		end
	end
end