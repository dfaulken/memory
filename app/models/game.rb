class Game < ApplicationRecord
	has_many :game_cards
	has_many :cards, through: :game_cards, dependent: :destroy

	validates :rows, presence: true, numericality: { greater_than: 1, less_than: 9 }
	validates :columns, presence: true, numericality: { greater_than: 1, less_than: 11 }
	validates :group_size, presence: true, numericality: { greater_than: 1, less_than: 11 }
	validates_with GameDimensionsValidator
	validates_with GameCardsValidator, if: :complete?

	def game_card_at(n)
		game_cards.where(position: n).first
	end

	def populate_cards!
		card_count = size / group_size
		cards = Card.where id: Card.pluck(:id).sample(card_count)
		vacant_positions = 1.upto(size).to_a.shuffle # this shuffle is the source of the game randomization
		cards.each do |card|
			group_size.times do
				position = vacant_positions.pop
				GameCard.create! game: self, card: card, position: position, solved: false
			end
		end
		update! complete: true
	end

	def position_at(row, col)
		raise ArgumentError, 'Row out of range'    unless 1.upto(rows).include? row
		raise ArgumentError, 'Column out of range' unless 1.upto(columns).include? col
		(row - 1) * columns + col
	end

	def size
		(rows || 0) * (columns || 0)
	end

	def solve(card)
		cards_to_solve = game_cards.where(card: card)
		return false unless cards_to_solve.present?
		cards_to_solve.update_all solved: true
	end
end
