class GameCard < ApplicationRecord
	belongs_to :game
	belongs_to :card

	default_scope -> { order :position }
	
	validates :position, presence: true, 
		uniqueness: { scope: :game }, 
		numericality: { greater_than: 0 }
	validate :card_cannot_cause_group_size_to_be_exceeded

	def card_cannot_cause_group_size_to_be_exceeded
		if game.game_cards.where(card: card).count >= game.group_size
			errors.add :card, 'has already been added the maximum number of times'
		end
	end
end
