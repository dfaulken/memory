class Card < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :image, presence: true, uniqueness: true
end
