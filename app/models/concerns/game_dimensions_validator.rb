class GameDimensionsValidator < ActiveModel::Validator
	def validate(record)
		if record.rows.present? && record.rows < 2
			record.errors.add :rows, 'must be greater than 1'
		end
		if record.columns.present? && record.columns < 2
			record.errors.add :columns, 'must be greater than 1'
		end
		if record.size.present? && record.group_size.present? && record.size % record.group_size != 0
			record.errors.add :group_size, 'must evenly divide game size'
		end
		if record.size.present? && record.group_size.present?
			card_count = Card.count
			max_possible_size = card_count * record.group_size
			if record.size > max_possible_size
				record.errors.add :size, "cannot be greater than #{max_possible_size} as there are currently only #{card_count} unique cards"
			end
		end
	end
end