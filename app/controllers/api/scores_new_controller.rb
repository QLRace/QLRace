class Api::ScoresNewController < Api::ApiController
  before_action :authenticate, :check_score

  def new
    return head :bad_request if @score.values.any?(&:blank?)
    return head :not_modified if map_disabled?

    wr_time = WorldRecord.world_record(@score[:map], @score[:mode]).time
    if Score.new_score(@score)
      @score['rank'] = Score.find_by(map: @score[:map], mode: @score[:mode],
                                     time: @score[:time]).rank
      @score['time_diff'] = wr_time ? @score[:time] - wr_time : 0

      render json: @score
    else
      return head :not_modified
    end
  end

  private

  def check_score
    begin
      map = params[:map].downcase
      mode = Integer(params[:mode])
      player_id = Integer(params[:player_id])
      time = Integer(params[:time])
      name = params[:name]
      match_guid = params[:match_guid]
      date = params[:date]
    rescue NoMethodError, TypeError, ArgumentError
      return head :bad_request
    end

    @score = { map: map, mode: mode, player_id: player_id, time: time,
               name: name, match_guid: match_guid, api_id: @user.id }
    @score[:date] = date if date.present?
  end

  def map_disabled?
    disabled_maps = %w(q3w2 q3w3 q3w5 q3w7 q3wcp1 q3wcp14 q3wcp17 q3wcp18
                       q3wcp22 q3wcp23 q3wcp5 q3wcp9 q3wxs1 q3wxs2)
    disabled_maps.include? @score[:map]
  end
end
