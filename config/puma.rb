# frozen_string_literal: true

shared_dir = '/var/www/qlrace/shared'

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch('PORT', 3000) if ENV.fetch('RAILS_ENV', 'development') == 'development'

puma_socket = ENV.fetch('PUMA_SOCKET', "unix://#{shared_dir}/tmp/sockets/puma.sock")
bind puma_socket if ENV.fetch('RAILS_ENV', 'development') == 'production'

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch('RAILS_ENV', 'development')

# Specifies the `pidfile` that Puma will use.
if ENV.fetch('RAILS_ENV', 'development') == 'production'
  pidfile "#{shared_dir}/tmp/pids/server.pid"
else
  pidfile 'tmp/pids/server.pid'
end

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
workers ENV.fetch('PUMA_WORKERS', 2)

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
preload_app!

# Attempts to route traffic to less-busy workers by causing them to delay
# listening on the socket, allowing workers which are not processing any
# requests to pick up new requests first.
# Only works on MRI. For all other interpreters, this setting does nothing.
wait_for_less_busy_worker 0.002

# Redirect STDOUT and STDERR to files specified. The append parameter
# specifies whether the output is appended, the default is false.
if ENV.fetch('RAILS_ENV', 'development') == 'production'
  stdout_redirect "#{shared_dir}/log/puma_stdout.log", "#{shared_dir}/log/puma_stderr.log", true
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
