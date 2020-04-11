# frozen_string_literal: true

class Api::ScoresApiController < Api::ApiController
  resource_description do
    resource_id 'records'
  end

  def_param_group :mode do
    param :mode,  [0, 1, 2, 3], desc: 'Default is 0, overrides weapons and physics params. 0: PQL Weapons, 1: PQL Strafe, 2: VQL Weapons, 3: VQL Strafe,'
    param :weapons, %w[true false], desc: 'Default is true'
    param :physics, %w[pql turbo vql classic], desc: 'Default is turbo, turbo is same as pql, classic is same as vql'
  end

  api :GET, '/player/:id', 'Player records'
  param :id, Integer, desc: 'SteamID64', required: true
  param_group :mode
  def player
    p_scores = Score.player_scores(params)
    render json: p_scores
  end

  api :GET, '/map/:map', 'Map records'
  param :map, String, desc: 'Map name', required: true
  param_group :mode
  param :limit, Integer, desc: 'Number of records which will be returned'
  def map
    render json: { records: Score.map_scores(params) }
  end

  api :GET, '/record/:id', 'Record'
  param :id, Integer, desc: 'Record Id', required: true
  def record
    return render json: {} unless Score.exists?(params[:record_id])

    s = Score.joins(:player)
             .select(:id, :map, :mode, :player_id, :time, :match_guid,
                     :checkpoints, :speed_start, :speed_end, :speed_top,
                     :speed_average, :name, 'scores.updated_at as date')
             .find(params[:record_id])

    j = s.as_json
    j['rank'] = s.rank_
    render json: j
  end
end
