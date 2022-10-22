# frozen_string_literal: true

# Production settings
if ENV.fetch('RAILS_ENV', 'development') == 'production'
  environment "production"
  shared_dir = '/var/www/qlrace/shared'
  pidfile "#{shared_dir}/tmp/pids/server.pid"
  stdout_redirect "#{shared_dir}/log/puma_stdout.log", "#{shared_dir}/log/puma_stderr.log", true
  bind puma_socket ENV.fetch('PUMA_SOCKET', "unix://#{shared_dir}/tmp/sockets/puma.sock")
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
