class GamesController < ApplicationController
  
  before_action :find_game, only: %i(delete show solve_card)

  def create
    @game = Game.new(params.require(:game).permit(:rows, :columns, :group_size))
    if @game.save && @game.populate_cards!
      redirect_to @game, notice: 'Created game.'
    else render 'main', notice: 'Could not create game.'
    end
  end

  def delete
    @game.destroy
    redirect_to :new, notice: 'Deleted game.'
  end

  def index
    redirect_to root_url
  end

  def new
    render 'main'
  end

  def show
    render 'main'
  end

  def solve_card # JSON only
    card = @game.cards.where(id: params.require(:card_id))
    if card.present?
      if @game.solve card
        head :ok
      else
        render json: { errors: @game.errors }, status: :unprocessable_entity and return
      end
    else head :not_found
    end
  end

  private

  def find_game
    @game = Game.includes(game_cards: :card).where(id: params.require(:id)).first
    respond_to do |format|
      format.html do
        unless @game
          redirect_to root_url, notice: "Could not find game with ID #{params[:id]}."
        end
      end
      format.json do
        unless @game
          head :not_found
        end
      end
    end
  end
end
