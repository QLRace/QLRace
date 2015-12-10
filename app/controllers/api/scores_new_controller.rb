class Api::ScoresNewController < Api::ApiController
  skip_before_action :verify_authenticity_token
  respond_to :json
  before_action :authenticate, :check_score

  def new
    head_status :bad_request and return if @score.values.any? &:blank?
    head_status :not_modified and return if map_disabled?

    Score.new_score(@score) ? head_status(:ok) : head_status(:not_modified)
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
    rescue NoMethodError, TypeError
      head_status :bad_request and return
    end

    @score = { map: map, mode: mode, player_id: player_id, time: time, name: name,
               match_guid: match_guid, api_id: @user.id }
    @score[:date] = date if date.present?
  end

  def map_disabled?
    disabled_maps = %w(q3w2 q3w3 q3w5 q3w7 q3wcp1 q3wcp14 q3wcp17 q3wcp18
                       q3wcp22 q3wcp23 q3wcp5 q3wcp9 q3wxs1 q3wxs2)
    disabled_maps.include? @score[:map]
  end
end
