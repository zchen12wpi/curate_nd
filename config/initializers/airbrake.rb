Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.host = 'https://errbit.library.nd.edu'
  config.port    = 443
  config.secure  = config.port == 443
  config.user_attributes = [:id, :username]
  config.ignore << "ActiveFedora::RecordNotFound"
  config.ignore << "URI::InvalidComponentError"
end
