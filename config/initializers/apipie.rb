Apipie.configure do |config|
  config.app_name                = 'Qlrace'
  config.app_info                = 'Qlrace.com API'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/apidoc'
  config.layout                  = 'apidoc.html.slim'
  config.validate                = false
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
end
