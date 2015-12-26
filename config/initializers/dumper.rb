Dumper::Agent.start(app_key: ENV["DUMPER_KEY"]) if Rails.env.production?
