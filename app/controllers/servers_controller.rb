# frozen_string_literal: true
class ServersController < ApplicationController
  def show
    @servers = Rails.cache.read('servers')
  end
end
