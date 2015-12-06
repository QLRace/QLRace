# Get server data
every 1.minute do
  rake "server_data:get"
end
