class StaticPagesController < ApplicationController
  def servers
    server = SourceServer.new("108.61.190.53", 27960)
    @players = server.players
    @info = server.info
  end
end
