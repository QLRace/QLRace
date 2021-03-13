# frozen_string_literal: true

servers = [
  '45.76.92.77:27970', '45.76.92.77:27971', '45.76.92.77:27980',
  '45.76.92.77:27981', 'de.qlrace.com:27960', 'de.qlrace.com:27961',
  'nl.qlrace.com:27960', 'na.qlrace.com:29760', 'na.qlrace.com:29761',
  'na.qlrace.com:29762', 'na-west.qlrace.com:29760', 'na-west.qlrace.com:29761',
  'na-west.qlrace.com:29762'
]

desc 'Get status of QLRace servers and save to cache'
task get_server_info: :environment do
  require 'steam-condenser'
  SteamSocket.timeout = 750

  server_status = []
  servers.each { |s| server_status << get_server_info(s) }

  data = { time: Time.now.utc.strftime('%H:%M:%S'),
           servers: server_status.compact }
  Rails.cache.write('servers', data)
end

def get_server_info(address)
  server = SourceServer.new(address)
  info = server.server_info

  num_players = "#{info[:number_of_players]}/#{info[:max_players]}"
  { name: info[:server_name], address: address,
    map: info[:map_name].downcase, num_players: num_players,
    players: get_players(server) }
rescue SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SteamCondenser::TimeoutError
  nil
end

def get_players(server)
  players = []
  server.players.each do |n, player|
    name = n.gsub(/\^[0-9]/, '') # remove colour codes from names
    time = player.score <= 0 ? 2_147_483_647 : player.score
    players << { name: name, time: time }
  end
  players.sort_by! { |k| k[:time] }
  players
end
