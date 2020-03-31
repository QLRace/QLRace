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
    if params[:map] == 'kool_slopes'
      if params[:key] ==  ENV['QLRACE_CUP_KEY']
        render json: { records: Score.map_scores(params) }
      else
        render json: {records: []}
      end
      return
    end
    render json: { records: Score.map_scores(params) }
  end

  api :GET, '/record/:id', 'Record'
  param :id, Integer, desc: 'Record Id', required: true
  def record
    if !Score.exists?(params[:record_id])
      render json: {}
      return
    end
    
    s = Score.find(params[:record_id])
    j = s.as_json.tap { |hash| hash['date'] = hash.delete 'updated_at' }
    j['rank'] = s.rank_
    render json: j
  end
end
