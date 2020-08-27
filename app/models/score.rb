# frozen_string_literal: true

# == Schema Information
#
# Table name: scores
#
#  id            :integer          not null, primary key
#  map           :string           not null
#  mode          :integer          not null
#  player_id     :bigint           not null
#  time          :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  match_guid    :uuid             not null
#  api_id        :integer
#  checkpoints   :integer          is an Array
#  speed_start   :float
#  speed_end     :float
#  speed_top     :float
#  speed_average :float
#

class Score < ApplicationRecord
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
      # return name and avg as nil, medals and records as empty arrays
      return { name: nil, id: nil, medals: [], records: [] }
    end

    query = 'SELECT * FROM player_scores(:p_id, :mode)'
    scores = Score.find_by_sql [query, { p_id: p.id, mode: mode }]

    total = 0
    medals = [0, 0, 0]

    scores.each do |score|
      total += score[:rank]
      medals[score[:rank] - 1] += 1 if score[:rank].between?(1, 3)
    end

    avg = total / scores.size.to_f

    { name: p.name, id: p.id, average: avg.round(2),
      medals: medals, records: scores }
  end

  def self.map_scores(params)
    mode = mode_from_params params
    map = params[:map].downcase
    total_scores = Score.where(map: map, mode: mode).count

    limit = params[:limit].to_i.positive? ? params[:limit].to_i : nil

    query = 'SELECT * FROM map_scores(:map, :mode, :limit, 0)'
    scores = Score.find_by_sql [query, { map: map, mode: mode, limit: limit }]
    { total_records: total_scores, records: scores }
  end

  def self.map_scores_paginated(params)
    mode = mode_from_params params
    map = params[:map].downcase
    total_scores = Score.where(map: map, mode: mode).count

    page = params[:page].to_i.positive? ? params[:page].to_i : 1

    limit = 50
    offset = (page - 1) * 50

    query = 'SELECT * FROM map_scores(:map, :mode, :limit, :offset)'
    scores = Score.find_by_sql [query, { map: map, mode: mode, limit: limit, offset: offset }]
    { total_records: total_scores,
      records: scores}
  end

  def self.player_score(map, mode, player_id)
    Score.find_or_initialize_by(map: map, mode: mode, player_id: player_id)
  end

  def self.update_score(score, new_score)
    score.time = new_score[:time]
    score.match_guid = new_score[:match_guid]
    score.api_id = new_score[:api_id]
    score.updated_at = new_score[:date] if new_score[:date]
    score.checkpoints = new_score[:checkpoints].presence || []
    score.speed_start = new_score[:speed_start] if new_score[:speed_start]
    score.speed_end = new_score[:speed_end] if new_score[:speed_end]
    score.speed_top = new_score[:speed_top] if new_score[:speed_top]
    score.speed_average = new_score[:speed_average] if new_score[:speed_average]
    score.save!
  end

  def self.mode_from_params(params)
    return params[:mode].to_i if %w[0 1 2 3].include? params[:mode]

    physics = if params[:physics]
                params[:physics].downcase
              elsif params[:factory]
                params[:factory].downcase
              else
                'pql'
              end

    w = params.fetch(:weapons, 'true')
    weapons = ActiveRecord::Type::Boolean.new.cast(w)
    return weapons ? 2 : 3 if %w[vql classic].include? physics

    weapons ? 0 : 1
  end

  private_class_method :mode_from_params, :update_score
end
