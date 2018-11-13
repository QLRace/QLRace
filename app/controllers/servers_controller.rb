# frozen_string_literal: true

class ServersController < ApplicationController
  # CSRF is not needed since GET requests are idempotent
  skip_before_action :verify_authenticity_token

  def show
    @servers = Rails.cache.read('servers')
  end
end
