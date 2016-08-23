# Get server data
every 2.minutes do
  rake 'get_server_info'
end

# Update player names to their current name on Steam
every 1.week do
  rake 'db:update_player_names'
end
