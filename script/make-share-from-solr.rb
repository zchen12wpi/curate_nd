#!/usr/bin/env ruby

# Create list of all objects from SOLR index, and place into a CSV file.
#
# The file will have a name in the form `curate-for-share-YYYYMMDD.csv`.
# Labels for the columns are in the first row of the CSV file.
#
# Set the environmental variable `SOLR_URL` to point to the solr index to query
# Set the environmental variable `PID_NAMESPACE` to change the namespace
# filtered out in the second file.
#
# The query run depends on some curate specific metadata fields, including:
#
#  * pid
#  * Creation date
#  * Modification date
#  * Object State (Active or Inactive or Deleted) [this should always be "A"]
#  * Active Fedora Model
#  * "Has Model"
#  * Title
#  * Human readable type
#  * Depositor
#  * Creator
#  * Read access group [i.e. public/registered or blank (== private)]
#
# Example usage:
#
#     ./make-share-from-solr.rb
#
# OR
#
#     env PID_NAMESPACE="temp:" ./make-share-from-solr.rb
#
# OR
#
#     env SOLR_URL="https://solr41prod.example.com:8443/solr/curate" ./make-share-from-solr.rb

require "csv"
require "date"
require "rsolr"

ROW_COUNT = 1000
SOLR_URL = ENV["SOLR_URL"] || "http://localhost:8983/solr/curate"
PID_NAMESPACE = ENV["PID_NAMESPACE"] || "und:"

class SolrToShare

  attr_reader :target_share_csv

  def initialize
    date_stamp = Date.today.strftime("%Y-%m-%d")
    @target_share_csv = "curate-for-share-#{date_stamp}.csv"
  end


  # take a record and either return nil, or the data ready to be put into a spreadsheet.
  def process_record(record)
    # filter out unwanted namespaces
    return nil unless record["id"].start_with?(PID_NAMESPACE)

    # remove Etd and GenericFiles and other unwanted objects
    return nil if %w(Etd FindingAid GenericFile Person Profile ProfileSection LinkedResource Hydramata::Group).include?(record["active_fedora_model_ssi"])

    # remove non-public items
    read_groups = record["read_access_group_ssim"]
    return nil unless !read_groups.nil? && read_groups.include?("public")

    # convert each id into a URL
    record["id"] = record["id"].sub(/^[^:]*:/, "https://curate.nd.edu/show/")
    record
  end

  def make_string(s)
    if s.respond_to?('join')
      s = s.join('|')
    end
    if s.respond_to?('gsub')
      s = s.gsub(/[\n\r]/, ' ')
    end
    return s
  end

  def run
    puts "Using SOLR_URL=#{SOLR_URL}"
    puts "Using PID_NAMESPACE=#{PID_NAMESPACE}"

    fields = [
            "id",
            "system_create_dtsi",
            "system_modified_dtsi",
            "object_state_ssi",
            "active_fedora_model_ssi",
            "human_readable_type_tesim",
            "depositor_tesim",
            "read_access_group_ssim",
            "desc_metadata__title_tesim",
            "desc_metadata__creator_tesim",
            "desc_metadata__abstract_tesim",
            "desc_metadata__description_tesim",
            "desc_metadata__identifier_tesim"
          ]
    solr = RSolr.connect url: SOLR_URL

    puts "opening #{self.target_share_csv}"
    CSV.open(self.target_share_csv, "wb:UTF-8") do |csv|
      csv << fields
      offset = 0
      loop do
        puts "Fetching 1000 at offset #{offset}..."
        response = solr.get 'select', params: {
          q: "*:*",
          start: offset,
          rows: ROW_COUNT,
          fl: fields
        }
        docs = response["response"]["docs"]
        docs.each do |record|
          new_record = process_record(record)
          unless new_record.nil?
            row = fields.map { |name| make_string(new_record[name]) }
            csv << row
          end
        end
        break if docs.length < ROW_COUNT
        offset += ROW_COUNT
      end
    end
  end
end

SolrToShare.new.run

