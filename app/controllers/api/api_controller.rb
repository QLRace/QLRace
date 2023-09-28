# frozen_string_literal: true

class Api::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?

  private

  def authenticate
    api_key = request.headers['X-Api-Key']
    @user = User.where(api_key: api_key).first if api_key
    head(:unauthorized) unless @user
  end

  def json_request?
    request.format.json?
  end
end
