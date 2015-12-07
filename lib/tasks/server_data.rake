namespace :server_data do
  desc 'TODO'
  task get: :environment do
    servers = []
    ips = %w(de.qlrace.com il.qlrace.com au.qlrace.com)
    ports = [27_960, 27_961, 27_970, 27_971]
    ips.each do |ip|
      ports.each do |port|
        servers << get_server_info(ip, port)
      end
    end

    servers << get_server_info('kr.qlrace.com', 27_007)
    servers << get_server_info('kr.qlrace.com', 27_008)

    data = { time: Time.now.strftime('%H:%M:%S'), servers: servers.compact }
    Rails.cache.write('servers', data)
  end
end

def get_server_info(ip, port)
  begin
    server = SourceServer.new(ip, port)
    ping = server.ping
    info = server.server_info
  rescue SocketError, Errno::ECONNREFUSED, SteamCondenser::TimeoutError
    return
  end
  name = info[:server_name]
  address = "#{ip}:#{port}"
  map = info[:map_name].downcase
  num_players = "#{info[:number_of_players]}/#{info[:max_players]}"
  players = []
  server.players.each do |name, player|
    # remove colour codes from names
    name_clean = name.gsub /\^[0-9]/, ''
    if player.score == -1 || player.score == 0
      time = 2_147_483_647
    else
      time = player.score
    end
    players << { name: name_clean, time: time }
  end
  players.sort_by! { |k| k[:time] }
  { name: name, address: address, map: map,
    num_players: num_players, players: players }
end
