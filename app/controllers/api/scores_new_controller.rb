class Api::ScoresNewController < Api::ApiController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  before_action :authenticate

  def new
    begin
      player_id = Integer(params[:player_id])
      name = params[:name]
      map = params[:map].downcase
      mode = Integer(params[:mode])
      time = Integer(params[:time])
    rescue TypeError
      render nothing: true, status: :bad_request
      return false
    end
    if Score.new_score(map, mode, player_id, time, name)
      render nothing: true, status: :ok
    else
      render nothing: true, status: :not_modified
    end
  end
end
