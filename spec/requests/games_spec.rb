require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe 'POST /solve_card' do
    before :each do
      Card.create! image: 'card_1.jpg', name: 'Card 1'
      Card.create! image: 'card_2.jpg', name: 'Card 2'
      game = Game.create! rows: 2, columns: 2, group_size: 2
      game.populate_cards!
    end
    let(:game) { Game.first }
    let(:card) { game.cards.first }
    let(:json_headers) { { 'ACCEPT' => 'application/json' } }
    context 'with invalid game ID' do
      it 'fails' do
        post "/games/0/solve_card", headers: json_headers
        expect(response).to have_http_status :not_found
      end
    end
    context 'with missing card ID' do
      it 'fails' do
        expect { 
          post "/games/#{game.id}/solve_card", headers: json_headers 
        }.to raise_error ActionController::ParameterMissing
      end
    end
    context 'with invalid card ID' do
      it 'fails' do
        post "/games/#{game.id}/solve_card", headers: json_headers, params: { card_id: 0 }
        expect(response).to have_http_status :not_found
      end
    end
    context 'with errors in solving card' do
      it 'fails' do
        game_id = game.id
        game = double(game)
        allow(game).to receive(:id).and_return game_id
        expect(game).to receive(:solve).with(card).and_return false
        post "/games/#{game.id}/solve_card", headers: json_headers, params: { card_id: card.id }
        expect(response).to have_http_status :unprocessable_entity
      end
    end
    context 'under normal conditions' do
      it 'works' do
        post "/games/#{game.id}/solve_card", headers: json_headers, params: { card_id: card.id }
        expect(response).to have_http_status :ok
      end
    end
  end
end
