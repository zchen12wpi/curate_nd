namespace :bendo do

  timestamp_file = '/home/app/curatend/shared/system/lastrun'.freeze

  desc 'Find modified records in SOLR, compare them fedora vs bendo, update bendo'
  task sync_with_fedora: :environment do
    require 'solr_tools'
    require 'fedora_tools'

    solr_list = SolrTools.changed_since(timestamp_file)

    STDERR.puts "#{solr_list.count} SOLR records changed " unless solr_list.count == 0

    fedora_list = FedoraTools.fetch_list(solr_list)

    STDERR.puts "#{fedora_list.count} fedora records fetched "

    fedora_list = FedoraTools.records_with_bendo(fedora_list)

    STDERR.puts "#{fedora_list.count} fedora records have bendo items "

    fedora_list.each do |record|
      puts "inline" if record.datastreams['bendo-item'].inline?
      puts "redirect" if record.datastreams['bendo-item'].redirect?
    end
  end
end
