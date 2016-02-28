class ServersController < ApplicationController
  def show
    @servers = Rails.cache.read('servers')
  end
end
