# frozen_string_literal: true

Rails.application.routes.draw do
  root "scores#home"
  get "recent", to: "scores#recent", as: "recent_scores"
  get "recentwrs", to: "scores#recent_wrs", as: "recent_wrs"
  get "map/:map", to: "scores#map", as: "map"
  get "player/:player_id", to: "scores#player", as: "player"
  get "player", to: redirect("players")
  get "players", to: "players#index", as: "players"
  get "mostwrs", to: "players#most_wrs", as: "most_wrs"
  get "players/autocomplete_player_name", as: "players_autocomplete"
  get "servers", to: "servers#show", as: "servers"

  apipie
  namespace :api, defaults: {format: "json"} do
    get "maps", to: "maps_api#maps"
    get "map/:map", to: "scores_api#map"
    get "player/:player_id", to: "scores_api#player"
    get "record/:record_id", to: "scores_api#record"
    post "new", to: "scores_new#new"
    root to: redirect("/apidoc"), via: :all
    match "*path", to: redirect("/apidoc"), via: :all
  end
end
