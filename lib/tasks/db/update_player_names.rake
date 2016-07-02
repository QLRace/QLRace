namespace :db do
  desc 'Update player names using steam api.'
  task update_player_names: :environment do
    require 'open-uri'

    abort('STEAM_API_KEY env variable is not set!') if ENV['STEAM_API_KEY'].nil?
    url = 'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/' \
           "?key=#{ENV['STEAM_API_KEY']}"

    sliced_ids = Player.pluck(:id).each_slice(100).to_a
    sliced_ids.each do |ids|
      response = JSON.parse(open("#{url}&steamids=#{ids.join(',')}").read)
      Player.transaction do
        response['response']['players'].each do |p|
          Player.update_player_name(p['steamid'], p['personaname'])
        end
      end
    end
  end
end
