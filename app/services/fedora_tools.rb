require 'rubydora'

class FedoraTools
   require 'pp'

  # connect to fedora and fetch objects in list
  # returns array of fedora  objects
  def self.fetch_list(pid_list)
    doc_list = {}
  
    # Try to connect to fedora, and search for the desired item
    # If either of these actions fail, handle it, and exit.
    begin
      fedora_config

      pid_list.each do |element|  
        doc = @fedora.find(element['id'])
        doc_list[element['id']] = doc unless doc.nil?
      end
    rescue StandardError => e
      puts "Error: #{e}"
      exit 1
    end

    doc_list
  end
   
  # return objects from the provided list without a backing bendo element
  # return the subset
  def self.records_without_bendo(input_list)
    output_list = {}
   
    input_list.each do |pid, record|
      output_list[pid]= record  if record.datastreams['bendo-item'].empty?
    end
    output_list
  end


  # remove objects from the provided list without a backing bendo element
  # return the subset
  def self.records_with_bendo(input_list)
    output_list = {}
   
    input_list.each do |pid, record|
      output_list[pid]= record.datastreams['bendo-item'].content  unless record.datastreams['bendo-item'].empty?
    end
    output_list
  end

  # return trues if fedora afmodel is a work type, false otherwise
  def self.is_work(afmodel)
    # parse info:fedora/afmodel:Whatever -> Whatever (use :)
    case afmodel.split(':')[2]
    when "Article", "Dataset", "Document", "Etd", "FindingAid", "Image", "Patent", "SeniorThesis", "Video", "LibraryCollection"
      return true
    else
      return false
    end
  end

  # return the pid/bendoitem map of worktype
  def self.get_works_pid_list(input_list)
    output_list = {}
   
    input_list.each do |pid, record|
      output_list[pid]= pid if is_work( record.models[record.models.length - 1])
    end
    output_list
  end

  # return the pid/bendoitem map of genericfiles
  def self.get_files_pid_list(input_list)
    output_list = {}
   
    # relationships methods seems broken- https://github.com/samvera/rubydora/issues/90
    # use RELS-EXT datastream - can't use rdf either in ruby 2.1, so it's an ugly parse
    input_list.each do |pid, record|
      output_list[pid]= record.datastreams['RELS-EXT'].content.sub!(/^.*isPartOf rdf:resource=['\"]info:fedora\/und:/m, "").sub!(/[\"'].*$/m, "")  if record.models[record.models.length - 1 ] == "info:fedora/afmodel:GenericFile"
    end
    output_list
  end

  # get SOLR connect info from solr.yml
  def self.fedora_config
    fedora_yaml ||= YAML.load(File.open(File.join(Rails.root, 'config/fedora.yml')))
    @fedora ||= Rubydora.connect(fedora_yaml[Rails.env])
  end
end
