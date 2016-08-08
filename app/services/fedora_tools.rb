require 'rubydora'

class FedoraTools

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

  # remove objects from the provided list without a backing bendo element
  # return the subset
  def self.records_with_bendo(input_list)
    output_list = []
   
    input_list.each do |pid, record|
      output_list.push(pid) unless record.datastreams['bendo-item'].empty?
    end
    output_list
  end

  # get SOLR connect info from solr.yml
  def self.fedora_config
    fedora_yaml ||= YAML.load(File.open(File.join(Rails.root, 'config/fedora.yml')))
    @fedora ||= Rubydora.connect(fedora_yaml[Rails.env])
  end
end
