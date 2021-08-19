require 'rails_helper'

RSpec.feature "Main page", type: :feature do
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

	scenario 'First load (root URL)' do
		visit '/'
		expect(page).to have_text 'Memory Game'
	end
	scenario 'Creating a game' do
		visit '/'
		fill_in 'Number of rows', with: 4
		fill_in 'Number of columns', with: 4
		fill_in 'Number of cards per group', with: 2
		click_button 'Create Game'
		expect(page).not_to have_selector '.errors'
		expect(page).to have_selector '#notice', text: 'Created game.'
	end
end