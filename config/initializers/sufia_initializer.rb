require 'curate/jobs/content_deposit_event_job'

Sufia.config do |config|
  config.temp_file_base = '/tmp'
  config.after_create_content = lambda {|generic_file, user|
    Sufia.queue.push(Curate::ContentDepositEventJob.new(generic_file.pid, user.user_key))
  }
  config.id_namespace = "und"
  config.fits_path = begin
    Rails.configuration.fits_path
  rescue NoMethodError
    "fits.sh"
  end
  config.fits_to_desc_mapping = begin
    Rails.configuration.fits_to_desc_mapping
  rescue NoMethodError => e
    { file_title: :title, file_author: :creator }
  end

  config.noid_template = '.reeddeeddedk'

  # try to load a noids server configuration
  # but it is okay if it doesn't exist
  config.noids = begin
                   {
                     server: ENV.fetch('NOIDS_SERVER'),
                     pool: ENV.fetch("NOIDS_POOL")
                   }
                 rescue KeyError
                   # file doesn't exist
                   # or yaml file does not define the current environment
                   nil
                 end

  config.max_days_between_audits = 7

  config.permission_levels = {
    "Choose Access"=>"none",
    "View/Download" => "read",
    "Edit" => "edit"
  }

  config.owner_permission_levels = {
    "Edit" => "edit"
  }

  config.queue = Sufia::Resque::Queue

  # Map hostnames onto Google Analytics tracking IDs
  #config.google_analytics_id = 'UA-99999999-1'

end
