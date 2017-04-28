#!/usr/bin/env ruby

# Create list of all objects from SOLR index, and place into CSV files.
#
# Labels for the columns are in the first row of the CSV file.
# The generated CSV files have names in the following
# forms where the number is the date the script was run.
#
#  * `all-20160419.csv`
#  * `curate-20160419.csv`
#  * `curate-non-etd-20160419.csv`
#
# The first CSV file contains a list of every object in SOLR.
#
# The second CSV file contains a list of items which are CurateND specific. It
# filters on those items whose id starts with `und:`. This file exists to work
# around a bug which indexes _everything_ in fedora into solr, even items with
# different namespaces.
#
# The third CSV file contains a list of all non-ETDs Works in CurateND. It is a
# little hackish, and may miss something. (suggestions on a better way to do
# this are welcome).
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
#     ./make-csv-of-solr.rb
#
# OR
#
#     env PID_NAMESPACE="temp:" ./make-csv-of-solr.rb
#
# OR
#
#     env SOLR_URL="https://solr41prod.example.com:8443/solr/curate" ./make-csv-of-solr.rb

require "date"
require "rsolr"

ROW_COUNT = 1000
SOLR_URL = ENV["SOLR_URL"] || "http://localhost:8983/solr/curate"
PID_NAMESPACE = ENV["PID_NAMESPACE"] || "und:"

class SolrToShare

  attr_reader :target_share_csv

  def initialize

    date_stamp = Date.today.strftime("%Y-%m-%d")
    target_share_json = "curate-for-share-#{date_stamp}.json"
    target_share_csv = "curate-for-share-#{date_stamp}.csv"
  end


  # take a record and either return nil, or the data ready to be put into a spreadsheet.
  def process_record(record)
    # filter out unwanted namespaces
    return nil unless record["id"].start_with?(PID_NAMESPACE)

    # remove Etd and GenericFiles and other unwanted objects
    return nil if %w(Etd GenericFile Person Profile ProfileSection LinkedResource Hydramata::Group).include?(record["active_fedora_model_ssi"])

    # convert each id into a URL
    record["id"] = record["id"].sub(/^[^:]*:/, "https://curate.nd.edu/show/")
    record
  end


  def run
    puts "Using SOLR_URL=#{SOLR_URL}"
    puts "Using PID_NAMESPACE=#{PID_NAMESPACE}"

    solr = RSolr.connect url: SOLR_URL

    offset = 0
    loop do
      puts "Fetching 1000 at offset #{offset}..."
      response = solr.get 'select', params: {
        q: "*:*",
        start: offset,
        rows: ROW_COUNT,
        fl: [
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
      }
      docs = response["response"]["docs"]
      docs.each do |record|
        new_record = process_record(record)
        if !new_record.nil?
          puts new_record.to_json
          return
        end
      end
      break if docs.length < ROW_COUNT
      offset += ROW_COUNT
    end
  end
end

SolrToShare.new.run

