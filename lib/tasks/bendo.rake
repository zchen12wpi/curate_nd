namespace :bendo do
  timestamp_file = '/home/app/curatend/shared/system/lastrun'.freeze

  desc 'Find modified records in SOLR, compare fedora vs bendo, update bendo'
  task sync_with_fedora: :environment do
    require 'solr_tools'
    require 'fedora_tools'
    require 'batch_ingest_tools'

    solr_list = SolrTools.changed_since(timestamp_file)

    if solr_list.nil?
      STDERR.puts 'No SOLR records have changed since the last query.'
      exit 0
    end

    FileUtils.touch(timestamp_file)

    STDERR.puts "#{solr_list.count} SOLR records changed "

    fedora_list = FedoraTools.fetch_list(solr_list)

    STDERR.puts "#{fedora_list.count} fedora records fetched "

    pid_list = FedoraTools.records_with_bendo(fedora_list)

    STDERR.puts "#{pid_list.count} fedora records have bendo items "

    BatchIngestTools.submit_pidlist(pid_list) if pid_list.count > 0
  end
end
