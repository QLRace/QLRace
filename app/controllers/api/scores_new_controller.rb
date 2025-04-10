# frozen_string_literal: true

module Api
  class ScoresNewController < Api::ApiController
    before_action :authenticate_api_user!, :check_score

    def new
      @score[:name] = @score[:player_id].to_s if @score[:name].blank?
      return head(:not_modified) unless @score[:player_id].to_s.start_with?("765611")
      return head(:bad_request) if @score.values.any?(&:blank?)
      return head(:not_modified) if map_disabled?

      return head(:not_modified) unless update_score?

      render(json: @score)
    end

    private

    def check_score
      @score = {}
      @score[:map] = params[:map].downcase
      @score[:mode] = Integer(params[:mode])
      @score[:player_id] = Integer(params[:player_id])
      @score[:time] = Integer(params[:time])
      @score[:name] = params[:name].gsub(/\^[0-7]/, "")
      @score[:match_guid] = params[:match_guid]
      @score[:date] = params[:date] if params[:date].present?
      @score[:api_user_id] = current_api_user.id
      if params[:checkpoints].present? && params[:checkpoints].all?(Integer)
        cps = params[:checkpoints].select(&:positive?)
        @score[:checkpoints] = cps
      end
      @score[:speed_start] = params[:speed_start] if params[:speed_start].present?
      @score[:speed_end] = params[:speed_end] if params[:speed_end].present?
      @score[:speed_top] = params[:speed_top] if params[:speed_top].present?
      @score[:speed_average] = params[:speed_average] if params[:speed_average].present?
    rescue NoMethodError, TypeError, ArgumentError
      head(:bad_request)
    end

    def update_score?
      @score[:tied] = Score.exists?(map: @score[:map], mode: @score[:mode], time: @score[:time])
      @score[:old_total_records] = Score.where(
        map: @score[:map],
        mode: @score[:mode],
      ).count

      old_pb = Score.find_by(
        map: @score[:map],
        mode: @score[:mode],
        player_id: @score[:player_id],
      )
      if old_pb
        @score[:old_rank] = old_pb.rank_
        @score[:old_time] = old_pb.time
      end

      wr_time = WorldRecord.world_record(@score[:map], @score[:mode]).time
      return false unless Score.new_score(@score)

      @score[:rank] = Score.find_by(
        map: @score[:map],
        mode: @score[:mode],
        player_id: @score[:player_id],
      ).rank_
      @score[:time_diff] = wr_time ? @score[:time] - wr_time : 0
      @score[:total_records] = Score.where(
        map: @score[:map],
        mode: @score[:mode],
      ).count
      true
    end

    def map_disabled?
      disabled_maps = [
        "q3w2",
        "q3w3",
        "q3w5",
        "q3w7",
        "q3wcp1",
        "q3wcp14",
        "q3wcp17",
        "q3wcp18",
        "q3wcp22",
        "q3wcp23",
        "q3wcp5",
        "q3wcp9",
        "q3wxs1",
        "q3wxs2",
      ]
      disabled_maps.include?(@score[:map])
    end
  end
end
