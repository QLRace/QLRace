Rails.application.routes.draw do
  root 'scores#home'
  get 'player/:player_id', to: 'scores#player', as: 'player'
  get 'player', to: redirect('/')
  get 'map/:map', to: 'scores#map', as: 'map'
  get 'players', to: 'players#index', as: 'players'
  get 'players/autocomplete_player_name', as: 'players_autocomplete'
  get 'servers', to: 'static_pages#servers', as: 'servers'

  apipie
  namespace :api, defaults: { format: 'json' } do
    get 'player/:player_id', to: 'scores_api#player'
    get 'map/:map', to: 'scores_api#map'
    post 'new', to: 'scores_new#new'
    root to: redirect('/apidoc'), via: :all
    match '*path', to: redirect('/apidoc'), via: :all
  end
end
