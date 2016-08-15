require 'rsolr'
require 'time'

# Tools to perform SOLR query via rsolr gem
class SolrTools
  # Check SOLR for records since timestamp file
  def self.changed_since(timestamp_file)
    from = get_fromtime(timestamp_file)
    to = get_totime
    get_solr_list(from, to)
  end

  # fromtime is mod time of timestamp filr- * if it doesn't exist
  #  SOLR queries accept time ranges in iso8601 format
  def self.get_fromtime(timestamp_file)
    return '*' unless FileTest.exists?(timestamp_file)
    File.mtime(timestamp_file).utc.iso8601
  end

  def self.get_totime
    'NOW'
  end

  # query solr over the specificied time range
  def self.get_solr_list(fromtime, totime)
    docs = []
    start = 0
    loop do
      solr_params = {
        rows: 100,
        start: start,
        fq: "id: und* AND timestamp:[ #{fromtime} TO #{totime}]",
        fl: 'id'
      }
      start += 100

      new_docs = rsolr.select params: solr_params

      break if new_docs['response']['docs'].count == 0
      docs += new_docs['response']['docs']
    end

    return docs if docs.count > 0
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
end
