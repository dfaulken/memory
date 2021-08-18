class GameCardsValidator < ActiveModel::Validator
	def validate(record)
		if record.game_cards.count != record.size
			record.errors.add :cards, "count does not match game size"
			return
		end

		positions = record.game_cards.pluck(:position).sort
		expected_positions = 1.upto(record.size).to_a
		expected_positions.each do |i|
			unless positions.include? i
				record.errors.add :cards, "do not include position #{i}"
			end
		end
		unexpected_positions = positions - expected_positions
		unexpected_positions.each do |i|
			record.errors.add :cards, "include unexpected position #{i}"
		end

		record.cards.each do |card|
			group_cards = record.game_cards.where(card: card)
			if group_cards.any?(&:solved?) && !group_cards.all?(&:solved?)
				record.errors.add :cards, "of name #{card.name} must be either all solved or all unsolved"
			end
		end
	end
end