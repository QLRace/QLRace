class Score < ActiveRecord::Base
  belongs_to :player
  validates :map, :mode, :player_id, :time, :match_guid, presence: true
  validates_inclusion_of :mode, in: 0..3
  validates :player, presence: true
  validates :player_id, uniqueness: { scope: [:map, :mode],
                                      message: 'Players may only have one record per map for each mode.' }

  def self.new_score(map, mode, player_id, time, match_guid, name)
    player = Player.where(id: player_id).first_or_initialize
    player.name = name
    player.save

    score = Score.where(map: map, mode: mode, player_id: player_id).first_or_initialize
    if score.time.nil? || time < score.time
      score.time = time
      score.match_guid = match_guid
      score.save
      WorldRecord.check(map, mode, player_id, time, match_guid)
      return true
    else
      return false
    end
  end

  def self.player_scores(params)
    mode = mode_from_params(params)
    begin
      player_id = Integer(params[:player_id])
      p = Player.find(player_id)
    rescue ArgumentError, ActiveRecord::RecordNotFound
      # player id is not an int or doesn't exist
      return
    end
    scores = []
    ranks = []
    p.scores.where(mode: mode).order(:map).pluck(:map).each do |map|
      Score.where(map: map, mode: mode).order(:time, :updated_at).each.with_index(1) do |score, rank|
        if score.player_id == player_id
          ranks << rank
          scores << { map: map, mode: mode, rank: rank, time: score.time, match_guid: score.match_guid,
                      date: score.updated_at }
          break
        end
      end
    end
    avg = ranks.inject { |sum, el| sum + el }.to_f / ranks.size
    [p.name, avg.round(2), scores]
  end

  def self.map_scores(params)
    mode = mode_from_params(params)
    scores = []
    limit = Integer(params.fetch(:limit, 0))
    Score.where(map: params[:map], mode: mode).order(:time, :updated_at).includes(:player).each.with_index(1) do |score, rank|
      scores << { mode: mode, rank: rank, player_id: score.player_id, name: score.player.name,
                  time: score.time, match_guid: score.match_guid, date: score.updated_at }
      break if rank >= limit && limit != 0
    end
    scores
  end

  private

  def self.mode_from_params(params)
    factory = params.fetch(:factory, 'turbo')
    w = params.fetch(:weapons, 'true')
    if params[:weapons].nil?
      weapons = true
    else
      weapons = ActiveRecord::Type::Boolean.new.type_cast_from_user(w)
    end
    if factory == 'classic'
      return weapons ? 2 : 3
    else
      return weapons ? 0 : 1
    end
  end
end
