Ezid::Client.configure do |config|
  config.user = ENV.fetch('DOI_USERNAME')
  config.password = ENV.fetch('DOI_PASSWORD')
  config.default_shoulder = ENV.fetch('DOI_SHOULDER')
  config.host = ENV.fetch('DOI_HOST')
  config.port = ENV.fetch('DOI_PORT')
end
