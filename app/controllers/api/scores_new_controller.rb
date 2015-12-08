class Api::ScoresNewController < Api::ApiController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  before_action :authenticate

  def new
    begin
      map = params[:map].downcase
      mode = Integer(params[:mode])
      player_id = Integer(params[:player_id])
      time = Integer(params[:time])
      name = params[:name]
      match_guid = params[:match_guid]
      date = params[:date]
    rescue NoMethodError, TypeError
      render nothing: true, status: :bad_request
      return false
    end

    if map.blank? || mode.blank? || player_id.blank? || time.blank? || name.blank? || match_guid.blank?
      render nothing: true, status: :bad_request
      return false
    end

    # Don't add new score for disabled maps.
    disabled_maps = %w(q3w2 q3w3 q3w5 q3w7 q3wcp1 q3wcp14 q3wcp17 q3wcp18
                       q3wcp22 q3wcp23 q3wcp5 q3wcp9 q3wxs1 q3wxs2)
    if disabled_maps.include? map
      render nothing: true, status: :not_modified
      return false
    end

    if Score.new_score(map, mode, player_id, time, match_guid, name, date, @user.id)
      # PB
      render nothing: true, status: :ok
    else
      # Not a PB
      render nothing: true, status: :not_modified
    end
  end
end
