class ServersController < ApplicationController
  def show
    @servers = []
    de_ip = Rails.env.production? ? 'localhost' : 'de.qlrace.com'
    ips = [de_ip, 'tx.qlrace.com', 'au.qlrace.com']
    ports = [27_960, 27_961]
    ips.each do |ip|
      ports.each do |port|
        @servers << get_server_info(ip, port)
      end
    end
    # Korean Servers
    @servers << get_server_info('kr.qlrace.com', 27_007)
    @servers << get_server_info('kr.qlrace.com', 27_008)
    # Remove any nil elements
    @servers.compact!
  end

  private

  def get_server_info(ip, port)
    begin
      server = SourceServer.new(ip, port)
      ping = server.ping
      info = server.server_info
    rescue SocketError, Errno::ECONNREFUSED, SteamCondenser::TimeoutError
      return
    end
    name = info[:server_name]
    address = ip == 'localhost' ? "de.qlrace.com:#{port}" : "#{ip}:#{port}"
    map = info[:map_name].downcase
    num_players = "#{info[:number_of_players]}/#{info[:max_players]}"
    players = []
    server.players.each do |name, player|
      name_clean = name.gsub /\^[0-9]/, ''
      time = player.score == -1 or player.score == 0 ? 2_147_483_647 : player.score
      players << { name: name_clean, time: time }
      players.sort_by! { |k| k[:time] }
    end
    { name: name, address: address, map: map,
      num_players: num_players, players: players }
  end
end
