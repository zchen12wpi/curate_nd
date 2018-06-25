namespace :bendo do
   
  # use BENDOSYNC_LASTRUN as lastrun file, if set- default is /home/app/curatend/shared/system/lastrun
  timestamp_file = ENV.has_key?('BENDOSYNC_LASTRUN') ? ENV['BENDOSYNC_LASTRUN'] :  '/home/app/curatend/shared/system/lastrun'.freeze

  desc 'Find modified records in SOLR, compare fedora vs bendo, update bendo'
  task sync_with_fedora: :environment do
    require 'solr_tools'
    require 'fedora_tools'
    require 'batch_ingestor'

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

  desc 'Find Pids of Works and Generic Files without bendo-item datastream'
  task find_fedora_only: :environment do
    require 'pp'

    solr_list = SolrTools.get_solr_list('2000-01-01T17:33:18Z','NOW')

    STDERR.puts "#{solr_list.count} und pids returned"

    fedora_list = FedoraTools.fetch_list(solr_list)

    STDERR.puts "#{solr_list.count} fedora objects returned"

    nobendo_list = FedoraTools.records_without_bendo(fedora_list)

    STDERR.puts "#{nobendo_list.count} fedora records without bendo-item datastreams "

    works_list = FedoraTools.get_works_pid_list(nobendo_list)

    STDERR.puts "#{works_list.count} works without bendo-item datastreams "

    files_list = FedoraTools.get_files_pid_list(nobendo_list)

    STDERR.puts "#{files_list.count} genericfiles without bendo-item datastreams "
    
    BatchIngestor.submit_fedora_only(works_list, files_list) if works_list.count > 0 || files_list.count > 0

    exit 0
  end
end
