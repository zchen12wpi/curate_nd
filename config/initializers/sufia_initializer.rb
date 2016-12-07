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

  config.cc_licenses = {
    'Creative Commons BY 4.0' => 'https://creativecommons.org/licenses/by/4.0/',
    'Creative Commons BY-SA 4.0' => 'https://creativecommons.org/licenses/by-sa/4.0/',
    'Creative Commons BY-ND 4.0' => 'https://creativecommons.org/licenses/by-nd/4.0/',
    'Creative Commons BY-NC 4.0' => 'https://creativecommons.org/licenses/by-nc/4.0/',
    'Creative Commons BY-NC-SA 4.0' => 'https://creativecommons.org/licenses/by-nc-sa/4.0/',
    'Creative Commons BY-NC-ND 4.0' => 'https://creativecommons.org/licenses/by-nc-nd/4.0/',
    'Creative Commons BY 3.0 United States' => 'http://creativecommons.org/licenses/by/3.0/us/',
    'Creative Commons BY 3.0 Unported' => 'https://creativecommons.org/licenses/by/3.0/',
    'Creative Commons BY-SA 3.0 United States' => 'http://creativecommons.org/licenses/by-sa/3.0/us/',
    'Creative Commons BY-NC 3.0 United States' => 'http://creativecommons.org/licenses/by-nc/3.0/us/',
    'Creative Commons BY-ND 3.0 United States' => 'http://creativecommons.org/licenses/by-nd/3.0/us/',
    'Creative Commons BY-NC-ND 3.0 United States' => 'http://creativecommons.org/licenses/by-nc-nd/3.0/us/',
    'Creative Commons BY-NC-SA 3.0 United States' => 'http://creativecommons.org/licenses/by-nc-sa/3.0/us/',
    'Public Domain Mark 1.0' => 'http://creativecommons.org/publicdomain/mark/1.0/',
    'CC0 1.0 Universal' => 'http://creativecommons.org/publicdomain/zero/1.0/',
    'All rights reserved' => 'All rights reserved'
  }

  config.cc_licenses_reverse = Hash[*config.cc_licenses.to_a.flatten.reverse]

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
