# frozen_string_literal: true

# Get server data
every 2.minutes do
  rake "get_server_info"
end

# Purge old authentication tokens
every 2.days, at: "8:30 am" do
  rake "db:purge_old_tokens"
end
