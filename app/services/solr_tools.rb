require 'rsolr'

class SolrTools
  # Check SOLR for records since timestamp file
  def self.changed_since(timestamp_file)
    from = get_fromtime(timestamp_file)
    to = get_totime
    pid_list = get_solr_list(from, to)
  end


  def self.get_fromtime(timestamp_file)
    return 'NOW-1DAY' 
  end

  def self.get_totime
    return 'NOW'
  end

  def self.get_solr_list(fromtime, totime)
    docs = []
    start = 0
    loop do
      solr_params = {
          rows: 100,
          start: start,
          fq: "id: und* AND timestamp:[ * TO NOW]",
          fl: "id",
      }
      start += 100

      new_docs = rsolr.select params: solr_params

      break if new_docs["response"]["docs"].count == 0
      docs += new_docs["response"]["docs"]
    end

    if docs.count > 0
      return  docs 
    end
  end

  def self.rsolr
    @rsolr ||= RSolr.connect url: solr_url
  end

  # get SOLR connect info from solr.yml
  def self.solr_url
    @solr_url ||= YAML.load(File.open(File.join(Rails.root, 'config/solr.yml')))
    STDERR.puts @sorl_url
    @solr_url[Rails.env]['url']
  end

  #build query 
  def self.query_params(fromtime, totime)
  end
end
