Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.current_environment = Rails.env
  config.release = Curate.configuration.build_identifier
  config.excluded_exceptions += ['ActiveFedora::RecordNotFound', 'ActiveRecord::RecordNotFound', 'ActiveFedora::ObjectNotFoundError', 'ActiveFedora::ActiveObjectNotFoundError', 'URI::InvalidComponentError', 'ActionController::UnknownFormat']
end
