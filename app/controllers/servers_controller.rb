class ServersController < ApplicationController
  def show
    buffer = File.open('tmp/servers.json', 'r').read
    json = JSON.parse buffer
    @time = json['time']
    @servers = json['servers']
  end
end
