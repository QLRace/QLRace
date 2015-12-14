Rails.application.routes.draw do
  root 'scores#home'
  get 'recentwrs', to: 'scores#recent_wrs', as: 'recent_wrs'
  get 'player/:player_id', to: 'scores#player', as: 'player'
  get 'player', to: redirect('/')
  get 'map/:map', to: 'scores#map', as: 'map'
  get 'players', to: 'players#index', as: 'players'
  get 'players/autocomplete_player_name', as: 'players_autocomplete'
  get 'servers', to: 'servers#show', as: 'servers'

  apipie
  namespace :api, defaults: { format: 'json' } do
    get 'maps', to: 'scores_api#maps'
    get 'map/:map', to: 'scores_api#map'
    get 'player/:player_id', to: 'scores_api#player'
    post 'new', to: 'scores_new#new'
    root to: redirect('/apidoc'), via: :all
    match '*path', to: redirect('/apidoc'), via: :all
  end

  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource
    end

    root controller: DashboardManifest::ROOT_DASHBOARD, action: :index
  end
end
