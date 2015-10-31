class ServersController < ApplicationController
  def show
    if Rails.env.production?
      ip = 'localhost'
    else
      ip = 'de.qlrace.com'
    end
    ips = [ip, 'tx.qlrace.com']
    ports = [27960, 27961]
    @servers = []
    ips.each do |ip|
      ports.each do |port|
        server = SourceServer.new(ip, port)
        logger.debug(server)
        begin
          ping = server.ping
          logger.debug "ping: #{ping}"
        rescue Errno::ECONNREFUSED, SteamCondenser::TimeoutError
          @servers << {}
        end
        info = server.server_info
        name = info[:server_name]
        ip = 'de.qlrace.com' if ip == 'localhost'
        address = "#{ip}:#{port}"
        logger.debug "ip: #{address}"
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
