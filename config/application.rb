require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qlrace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.active_record.observers = :world_record_observer

    # Use dalli(memcache) as default cache store.
    config.cache_store = :dalli_store, {
      namespace: 'qlrace',
      expires_in: 1.hour
    }
  end
end
