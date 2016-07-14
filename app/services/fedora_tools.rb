require 'rsolr'

class FedoraTools
  # Check fedora for records since timestamp file
  def self.changed_since(timestamp_file)
    re timestamp_file
  end

  def self.get_fromtime(timestamp_file)
  end

  def self.get_totime
  end

  def self.get_solr_list(fromtime, totime)
  end

  def self.rsolr
    @rsolr ||= RSolr.connect url: solr_url
  end

  def self.solr_url
    @solr_url ||= YAML.load(File.open(File.join(Rails.root, "config/solr.yml")))
    @solr_url[Rails.env]['url']
  end

  def self.solr_params(fromtime, totime)
  end
end
