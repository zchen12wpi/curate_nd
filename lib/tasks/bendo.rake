namespace :bendo do

  timestamp_file = '/home/app/curatend/shared/system/lastrun'.freeze

  desc 'yada yada yada'
  task sync_with_fedora: :environment do
    require 'fedora_tools'

    FedoraTools.changed_since(timestamp_file)
  end
end
