require 'rails_helper'

RSpec.describe GameCard, type: :model do
	it 'does not allow too many cards of the same type' do
		card_a = Card.create! image: 'image.jpg', name: 'Card 1'
		Card.create! image: 'image2.jpg', name: 'Card 2'
		game = Game.create! rows: 2, columns: 2, group_size: 2

		GameCard.create! game: game, card: card_a, position: 1
		GameCard.create! game: game, card: card_a, position: 2
		third_game_card = GameCard.new game: game, card: card_a, position: 3
		expect(third_game_card).not_to be_valid
	end
end