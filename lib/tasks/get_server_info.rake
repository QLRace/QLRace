# frozen_string_literal: true
desc 'Get status of QLRace servers and save to cache'
task get_server_info: :environment do
  require 'steam-condenser'

  servers = []
  ips = ['de.qlrace.com', 'il.qlrace.com', 'au.qlrace.com']
  ports = [27_960, 27_961, 27_962, 27_963, 27_970, 27_971, 27_972, 27_973]
  ips.each do |ip|
    ports.each { |port| servers << get_server_info(ip, port) }
  end

  # RU server
  servers << get_server_info('91.226.93.118', 27_970)

  ports = [27_960, 27_961, 27_962, 27_970]
  ports.each { |port| servers << get_server_info('kr.qlrace.com', port) }

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
rescue SocketError, Errno::ECONNREFUSED, SteamCondenser::TimeoutError
  return
end
