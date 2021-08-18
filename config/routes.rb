Rails.application.routes.draw do
  root to: 'games#new'

  resources :games, except: %i(edit update) do
    member do
      post :solve_card
    end
  end
end
