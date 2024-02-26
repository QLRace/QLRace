# frozen_string_literal: true

class ApiUsers::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  def create
    token_expires_in = 1.hour
    user = warden.authenticate!(auth_options)
    token = Tiddle.create_and_return_token(user, request, expires_in: token_expires_in)
    render json: {authentication_token: token, expires_in: token_expires_in}
  end

  def destroy
    Tiddle.expire_token(current_user, request) if current_user
    render json: {}
  end

  private

  # this is invoked before destroy and we have to override it
  def verify_signed_out_user
  end
end
