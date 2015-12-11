# Get server data
every 2.minutes do
  rake 'server_data:get'
end
