# frozen_string_literal: true

# == Schema Information
#
# Table name: scores
#
#  id         :integer          not null, primary key
#  map        :string           not null
#  mode       :integer          not null
#  player_id  :bigint           not null
#  time       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_guid :uuid             not null
#  api_id     :integer
#

class Score < ActiveRecord::Base
  belongs_to :player
  validates :map, :mode, :player_id, :time, :match_guid, :player, presence: true
  validates :mode, inclusion: { in: 0..3 }
  validates :time, numericality: { only_integer: true,
                                   greater_than: 0 }
  validates :player_id, uniqueness: { scope: %i[map mode],
                                      message: 'Players may only have one record
                                                per map for each mode.' }

  def rank_
    Score.where(map: map, mode: mode).where('time < ?', time).count + 1
  end

  def self.new_score(score)
    Player.update_player_name(score[:player_id], score[:name])

    s = player_score(score[:map], score[:mode], score[:player_id])
    return false unless s.time.nil? || score[:time] < s.time

    update_score(s, score)
    WorldRecord.check(score)
    true
  end

  def self.player_scores(params)
    mode = mode_from_params(params)
    begin
      player_id = Integer(params[:player_id])
      p = Player.find(player_id)
    rescue ArgumentError, ActiveRecord::RecordNotFound
      # player id is not an int or doesn't exist
      # return name and avg as nil, medals and scores as empty arrays
      return { name: params[:player_id] }
    end

    query = <<-SQL
    SELECT s.id, s.map, s.mode, s.time, s.checkpoints, s.speed_start,
    s.speed_start, s.speed_end, s.speed_top, s.speed_average,
    s.match_guid, s.updated_at AS date, s.time, (
      SELECT (COUNT(*) + 1) FROM scores s_
      WHERE s_.map = s.map AND s_.mode = s.mode AND (s_.time < s.time)
    ) AS rank, (
      SELECT COUNT(*) FROM scores s_
      WHERE s_.map = s.map AND s_.mode = s.mode
    ) AS total_records
    FROM scores s
    WHERE s.mode = :mode AND s.player_id = :player_id
    ORDER BY map
    SQL
    scores = Score.find_by_sql [query, { mode: mode, player_id: p.id }]

    avg = scores.map { |s| s[:rank] }.reduce(0, :+) / scores.size.to_f
    medals = [
      scores.count { |s| s[:rank] == 1 },
      scores.count { |s| s[:rank] == 2 },
      scores.count { |s| s[:rank] == 3 }
    ]
    { name: p.name, id: p.id, average: avg.round(2),
      medals: medals, scores: scores }
  end

  def self.map_scores(params)
    mode = mode_from_params params
    map = params[:map]
    limit = params[:limit].to_i.positive? ? params[:limit].to_i : nil
    query = <<-SQL
    SELECT rank() OVER (ORDER BY time), scores.id, mode, player_id, name, time,
           scores.checkpoints, scores.speed_start, scores.speed_end, scores.speed_top,
           scores.speed_average, match_guid, scores.updated_at as date
    FROM scores
    INNER JOIN players
    ON scores.player_id = players.id
    WHERE mode = :mode AND map = :map
    ORDER BY rank, date
    LIMIT :limit
    SQL
    Score.find_by_sql [query, { mode: mode, map: map, limit: limit }]
  end

  def self.player_score(map, mode, player_id)
    Score.find_or_initialize_by(map: map, mode: mode, player_id: player_id)
  end

  def self.update_score(score, new_score)
    score.time = new_score[:time]
    score.match_guid = new_score[:match_guid]
    score.api_id = new_score[:api_id]
    score.updated_at = new_score[:date] if new_score[:date]
    if not new_score[:checkpoints].present?
      score.checkpoints = []
    else
      score.checkpoints = new_score[:checkpoints]
    end
    score.speed_start = new_score[:speed_start] if new_score[:speed_start]
    score.speed_end = new_score[:speed_end] if new_score[:speed_end]
    score.speed_top = new_score[:speed_top] if new_score[:speed_top]
    score.speed_average = new_score[:speed_average] if new_score[:speed_average]
    score.save!
  end

  def self.mode_from_params(params)
    if %w(0 1 2 3).include? params[:mode]
      return params[:mode].to_i
    end
    physics = if params[:physics]
                params[:physics]
              elsif params[:factory]
                params[:factory]
              else
                'pql'
              end

    w = params.fetch(:weapons, 'true')
    weapons = ActiveRecord::Type::Boolean.new.type_cast_from_user(w)
    return weapons ? 2 : 3 if %w(vql classic).include? physics

    weapons ? 0 : 1
  end

  private_class_method :mode_from_params, :update_score
end
