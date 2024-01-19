# frozen_string_literal: true

Apipie.configure do |config|
  config.api_base_url = '/api'
  config.app_info = 'QLRace.com API'
  config.app_name = 'QLRace'
  config.doc_base_url = '/apidoc'
  config.translate = false
  # config.layout = 'apidoc.html.slim'
  config.reload_controllers = Rails.env.development?
  config.validate = false
  # where is your API defined?
  config.api_controllers_matcher = Rails.root.join('app/controllers/api/**/*.rb').to_s
end
