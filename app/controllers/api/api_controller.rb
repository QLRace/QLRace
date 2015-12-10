class Api::ApiController < ActionController::Base
  private

  def authenticate
    api_key = request.headers['X-Api-Key']
    @user = User.where(api_key: api_key).first if api_key
    head_status :unauthorized unless @user
  end

  def head_status(status)
    head status: status
  end
end
