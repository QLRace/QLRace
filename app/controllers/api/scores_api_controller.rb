class Api::ScoresApiController < Api::ApiController
  respond_to :json

  resource_description do
    resource_id 'records'
  end

  def_param_group :mode do
    param :weapons, %w(true false), desc: 'Default is true'
    param :factory, %w(turbo classic), desc: 'Default is turbo'
  end

  api :GET, '/player/:id', 'Player records'
  param :id, Integer, desc: 'Player Steam ID', required: true
  param_group :mode
  def player
    name, average, medals, scores = Score.player_scores(params)
    respond_with({ name: name, average: average, medals: medals,
                   records: scores }.to_json)
  end

  api :GET, '/map/:map', 'Map records'
  param :map, String, desc: 'Map name', required: true
  param_group :mode
  param :limit, Integer, desc: 'Number of records which will be returned'
  def map
    scores = Score.map_scores(params)
    respond_with({ records: scores }.to_json)
  end

  api :GET, '/maps', 'List of all maps'
  def maps
    maps = WorldRecord.distinct(:map).order(:map).pluck(:map)
    respond_with(maps: maps)
  end
end
