# frozen_string_literal: true

class Api::ScoresApiController < Api::ApiController
  resource_description do
    resource_id 'records'
  end

  def_param_group :mode do
    param :weapons, %w[true false], desc: 'Default is true'
    param :physics, %w[turbo classic], desc: 'Default is turbo'
  end

  api :GET, '/player/:id', 'Player records'
  param :id, Integer, desc: 'SteamID64', required: true
  param_group :mode
  def player
    p_scores = Score.player_scores(params)
    p_scores[:records] = p_scores.delete :scores
    render json: p_scores
  end

  api :GET, '/map/:map', 'Map records'
  param :map, String, desc: 'Map name', required: true
  param_group :mode
  param :limit, Integer, desc: 'Number of records which will be returned'
  def map
    render json: { records: Score.map_scores(params) }
  end
end
