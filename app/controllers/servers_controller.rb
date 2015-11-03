class ServersController < ApplicationController
  def show
    ip = Rails.env.production? ? 'localhost' : 'de.qlrace.com'
    ips = [ip, 'tx.qlrace.com']
    ports = [27960, 27961]
    @servers = []
    ips.each do |ip|
      ports.each do |port|
        server = SourceServer.new(ip, port)
        logger.debug "#{ip}:#{port}"
        begin
          ping = server.ping
          logger.debug "ping: #{ping}"
          info = server.server_info
        rescue Errno::ECONNREFUSED, SteamCondenser::TimeoutError
          return
        end
        name = info[:server_name]
        address = ip == 'localhost' ? "de.qlrace.com:#{port}" : "#{ip}:#{port}"
        map = info[:map_name].downcase
        num_players = "#{info[:number_of_players]}/#{info[:max_players]}"
        players = []
        server.players.each do |name, player|
          name_clean = name.gsub /\^[0-9]/, ''
          time = player.score == 2147483647 ? 0 : player.score
          players << { name: name_clean, time: player.score }
          players.sort_by! { |k| k[:time] }
        end
        @servers << { name: name, address: address, map: map,
                      num_players: num_players, players: players }
      end
    end
  end
end
