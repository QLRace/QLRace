# frozen_string_literal: true

desc 'Get status of QLRace servers and save to cache'
task get_server_info: :environment do
  require 'steam-condenser'
  SteamSocket.timeout = 500

  servers = []

  # Tuna, Pork, Sorgy, Hydra servers (DE)
  ports = [27_970, 27_971, 27_980, 27_981]
  ports.each { |port| servers << get_server_info('45.76.92.77', port) }

  # DF physics servers (EU AND NA)
  ips = ['eu.qlrace.com', 'na.qlrace.com']
  ports = [27_960, 27_961, 27_962]
  ips.each do |ip|
    ports.each { |port| servers << get_server_info(ip, port) }
  end

  # DE DF physics servers
  ports = [27_960, 27_961]
  ports.each { |port| servers << get_server_info('de.qlrace.com', port) }

  # NL DF physics server
  servers << get_server_info('nl.qlrace.com', 27_960)

  data = { time: Time.now.utc.strftime('%H:%M:%S'), servers: servers.compact }
  Rails.cache.write('servers', data)
end

def get_server_info(ip, port)
  server = SourceServer.new(ip, port)
  info = server.server_info

  players = []
  server.players.each do |n, player|
    name = n.gsub(/\^[0-9]/, '') # remove colour codes from names
    time = player.score <= 0 ? 2_147_483_647 : player.score
    players << { name: name, time: time }
  end

  players.sort_by! { |k| k[:time] }
  num_players = "#{info[:number_of_players]}/#{info[:max_players]}"
  { name: info[:server_name], address: "#{ip}:#{port}",
    map: info[:map_name].downcase, num_players: num_players, players: players }
rescue SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SteamCondenser::TimeoutError
  nil
end
