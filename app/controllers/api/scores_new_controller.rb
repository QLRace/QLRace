class Api::ScoresNewController < Api::ApiController
  before_action :authenticate, :check_score

  def new
    return head :bad_request if @score.values.any?(&:blank?)
    return head :not_modified if map_disabled?

    return head :not_modified unless update_score?
    render json: @score
  end

  private def check_score
    @score = {}
    @score[:map] = params[:map].downcase
    @score[:mode] = Integer(params[:mode])
    @score[:player_id] = Integer(params[:player_id])
    @score[:time] = Integer(params[:time])
    @score[:name] = params[:name]
    @score[:match_guid] = params[:match_guid]
    @score[:date] = params[:date] if params[:date].present?
    @score[:api_id] = @user.id
  rescue NoMethodError, TypeError, ArgumentError
    return head :bad_request
  end

  private def update_score?
    old_pb = Score.find_by(map: @score[:map], mode: @score[:mode],
                           player_id: @score[:player_id])
    if old_pb
      @score[:old_rank] = old_pb.rank_
      @score[:old_time] = old_pb.time
    end

    wr_time = WorldRecord.world_record(@score[:map], @score[:mode]).time
    if Score.new_score(@score)
      @score[:rank] = Score.find_by(map: @score[:map], mode: @score[:mode],
                                    player_id: @score[:player_id]).rank_
      @score[:time_diff] = wr_time ? @score[:time] - wr_time : 0
      return true
    end
  end

  private def map_disabled?
    disabled_maps = %w(q3w2 q3w3 q3w5 q3w7 q3wcp1 q3wcp14 q3wcp17 q3wcp18
                       q3wcp22 q3wcp23 q3wcp5 q3wcp9 q3wxs1 q3wxs2)
    disabled_maps.include? @score[:map]
  end
end
