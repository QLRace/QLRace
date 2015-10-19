class Api::ScoresApiController < Api::ApiController
  respond_to :json

  resource_description do
    resource_id 'records'
  end

  def_param_group :mode do
    param :weapons, %w(true false), desc: 'Default is true'
    param :ruleset, %w(pql vql), desc: 'Default is pql'
  end

  api :GET, '/player/:id', 'Player records'
  param :id, Integer, desc: 'Player Steam ID', required: true
  param_group :mode
  def player
    name, average, scores = Score.player_scores(params)
    respond_with({ name: name, average: average, records: scores }.to_json)
  end

  api :GET, '/map/:map', 'Map records'
  param :map, String, desc: 'Map name', required: true
  param_group :mode
  param :limit, Integer, desc: 'Number of records which will be returned'
  def map
    scores = Score.map_scores(params)
    respond_with({ records: scores }.to_json)
  end
end
