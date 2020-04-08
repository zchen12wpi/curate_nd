namespace :bendo do
   
  # use BENDOSYNC_LASTRUN as lastrun file, if set- default is /home/app/curatend/shared/system/lastrun
  # also, BENDOSYNC_TOFILE is avail via SolrTools- default is /home/app/curatend/shared/system/totime.
  # in normal operation, BENDOSYNC_TOFILE is absent, and totime defaults to "NOW'
  # in normal operation, both items with and without bendo ids are processed.
  # Either step can be skipped by setting BENDOSYNC_SKIP_BENDOITEMS or BENDOSYNC_SKIP_NONBENDOITEMS
  #
  timestamp_file = ENV.has_key?('BENDOSYNC_LASTRUN') ? ENV['BENDOSYNC_LASTRUN'] :  '/home/app/curatend/shared/system/lastrun'.freeze
  do_bendo_items = ENV.has_key?('BENDOSYNC_SKIP_BENDOITEMS') ? false : true
  do_nonbendo_items = ENV.has_key?('BENDOSYNC_SKIP_NONBENDOITEMS') ? false : true

  desc 'Find modified records in SOLR, compare fedora vs bendo, update bendo'
  task sync_with_fedora: :environment do
    require 'solr_tools'
    require 'fedora_tools'
    require 'batch_ingestor'

    solr_list = SolrTools.changed_since(timestamp_file)

    #FileUtils.touch(timestamp_file)

    # See what records have chnaged in the totime - fromtime interval
    # this list will exclude Profiles, Persons, Profile Sections, and Hydramata Groups
    if solr_list.nil?
      STDERR.puts 'No SOLR records have changed since the last query.'
      exit 0
    end

    STDERR.puts "#{solr_list.count} SOLR records changed "

    fedora_list = FedoraTools.fetch_list(solr_list)

    STDERR.puts "#{fedora_list.count} fedora records fetched "

    bendo_list = {}
    nonbendo_list = {}

    if ( do_bendo_items == true )
      bendo_list = FedoraTools.records_with_bendo(fedora_list)
      STDERR.puts "#{bendo_list.count} fedora records have bendo items "
      STDERR.puts bendo_list
    end

    if ( do_nonbendo_items == true )
      nobendo_list = FedoraTools.records_without_bendo(fedora_list)
      STDERR.puts "#{nobendo_list.count} fedora records without bendo-item datastreams "
      nobendo_list = FedoraTools.setup_bendo_datastreams(nobendo_list) if nobendo_list.count > 0
      STDERR.puts nobendo_list
    end
    exit 0

    BatchIngestor.start_reingest(pid_list) if pid_list.count > 0
  end
end
