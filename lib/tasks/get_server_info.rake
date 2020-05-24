# frozen_string_literal: true

desc 'Get status of QLRace servers and save to cache'
task get_server_info: :environment do
  require 'steam-condenser'
  SteamSocket.timeout = 750
  servers = [
    '45.76.92.77:27970', '45.76.92.77:27971', '45.76.92.77:27980',
    '45.76.92.77:27981', 'eu.qlrace.com:27960', 'eu.qlrace.com:27961',
    'eu.qlrace.com:27962', 'de.qlrace.com:27960', 'de.qlrace.com:27961',
    'nl.qlrace.com:27960', 'na.qlrace.com:27960', 'na.qlrace.com:27961',
    'na.qlrace.com:27962', '149.28.72.79:27960', '149.28.72.79:27961',
    '149.28.72.79:27962', '207.148.102.141:27960', '207.148.102.141:27961',
    '207.148.102.141:27962'
  ]
  server_status = []

  servers.each { |s| server_status << get_server_info(s) }

  data = { time: Time.now.utc.strftime('%H:%M:%S'),
           servers: server_status.compact }
  Rails.cache.write('servers', data)
end

def get_server_info(address)
  server = SourceServer.new(address)
  info = server.server_info

  players = []
  server.players.each do |n, player|
    name = n.gsub(/\^[0-9]/, '') # remove colour codes from names
    time = player.score <= 0 ? 2_147_483_647 : player.score
    players << { name: name, time: time }
  end

  players.sort_by! { |k| k[:time] }
  num_players = "#{info[:number_of_players]}/#{info[:max_players]}"
  { name: info[:server_name], address: address,
    map: info[:map_name].downcase, num_players: num_players, players: players }
rescue SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SteamCondenser::TimeoutError
  nil
end
