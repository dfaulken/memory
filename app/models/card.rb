class Card < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :image, presence: true, uniqueness: true
	# TODO how to make sure that images definitely exist?
end
