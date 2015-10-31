class ServersController < ApplicationController
  def show
    ips = %w(de.qlrace.com tx.qlrace.com)
    ports = [27960, 27961]
    @servers = []
    ips.each do |ip|
      ports.each do |port|
        server = SourceServer.new(ip, port)
        begin
          ping = server.ping
        rescue Errno::ECONNREFUSED
          servers << ''
        end
        info = server.server_info
        name = info[:server_name]
        address = "#{ip}:#{port}"
        map = info[:map_name].downcase
        num_players = "#{info[:number_of_players]}/#{info[:max_players]}"
        players = []
        server.players.each do |name, player|
          players << { name: name, time: player.score }
          players.sort_by! { |k| k[:time] }
        end
        @servers << { name: name, address: address, map: map,
                      num_players: num_players, players: players }
      end
    end
  end
end
