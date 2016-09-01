namespace :bendo do
  # use BENDOSYNC_LASTRUN as lastrun file, if set- default is /home/app/curatend/shared/system/lastrun
  timestamp_file = ENV.has_key?('BENDOSYNC_LASTRUN') ? ENV['BENDOSYNC_LASTRUN'] :  '/home/app/curatend/shared/system/lastrun'.freeze

  desc 'Find modified records in SOLR, compare fedora vs bendo, update bendo'
  task sync_with_fedora: :environment do
    require 'solr_tools'
    require 'fedora_tools'
    require 'batch_ingest_tools'

    solr_list = SolrTools.changed_since(timestamp_file)

    FileUtils.touch(timestamp_file)

    if solr_list.nil?
      STDERR.puts 'No SOLR records have changed since the last query.'
      exit 0
    end

    STDERR.puts "#{solr_list.count} SOLR records changed "

    fedora_list = FedoraTools.fetch_list(solr_list)

    STDERR.puts "#{fedora_list.count} fedora records fetched "

    pid_list = FedoraTools.records_with_bendo(fedora_list)

    STDERR.puts "#{pid_list.count} fedora records have bendo items "

    BatchIngestor.start_reingest(pid_list) if pid_list.count > 0
  end
end
