#!/usr/bin/env ruby

# Push the data in a CSV file to the SHARE push gateway.
# Parameters can be configured using environment variables.
#
# Sample usage is
#
#     env SHARE_HOST=https://share.osf.io SHARE_TOKEN=1234567890 ./push-to-share.rb data-file.csv
#

require 'csv'
require 'share_notify'

if ARGV.length < 1
  puts <<-EOS
usage: push-to-share.rb <list of csv files>

Push the records in all the csv files to the SHARE Push Gateway.
Status messages are printed to STDOUT.

Configure using the SHARE_HOST and SHARE_TOKEN environment variables.
EOS

  exit 2
end

share_host = ENV["SHARE_HOST"] || "https://staging-share.osf.io"
share_token = ENV["SHARE_TOKEN"]

puts "Using SHARE_HOST=#{share_host}"
puts "Using SHARE_TOKEN=#{share_token}"

ShareNotify.configure "host" => share_host, "token" => share_token
api = ShareNotify::ApiV2.new

# map curate work types to approporate SHARE work types
# a SHARE work of type nil means to not submit the item
#
# Possible SHARE types:
# CreativeWork, DataSet, Patent, Poster, Presentation, Publication
# Article, Book, ConferencePaper, Dissertation, Preprint, Project,
# Registration, Report, Thesis, WorkingPaper, Repository, Retraction, Software
typemap = {
  "Senior Thesis": "",
  "Dataset": "DataSet",
  "Article": "Article",
  "Document": "",
  "Image": nil,
  "Presentation": "Presentation",
  "White Paper": "Report",
  "Book": "Book",
  "Collection": nil,
  "Software": "Software",
  "Audio": nil,
  "Report": "Report",
  "Video": nil,
  "Pamphlet": nil,
  "Newsletter": nil,
  "Book Chapter": "Book",
  "OSF Archive": "Project",
  "Patent": "Patent"
}


overall_record_count = 0
error_count = 0
ARGV.each do |csv_filename|
  puts "Reading #{csv_filename}"
  file_record_count = 0
  first_line = true
  columns = {} # mapping from column name -> column index for this csv file
  CSV.foreach(csv_filename) do |row|
    if first_line
      # first row is the column labels
      row.each_with_index do |label, index|
        columns[label] = index
      end
      first_line = false
      next
    end
    overall_record_count += 1
    file_record_count += 1

    id = row[columns["id"]]
    modified = row[columns["system_modified_dtsi"]]
    title = row[columns["desc_metadata__title_tesim"]]
    abstract = row[columns["desc_metadata__abstract_tesim"]]
    description = row[columns["desc_metadata__description_tesim"]]
    contributors = row[columns["desc_metadata__creator_tesim"]]
    contributors = (contributors || "").split("|")
    type = typemap.fetch(row[columns["human_readable_type_tesim"]], "")
    # nil == skip this work, "" == idk what this is
    next if type.nil?
    if type == ""
      puts "Unknown Curate work type #{row[columns['human_readable_type_tesim']]}"
      type = "CreativeWork"
    end

    puts "#{overall_record_count} / #{file_record_count} Pushing #{id}"
    document = ShareNotify::PushDocument.new(id, modified)
    document.title = title
    document.type = type
    document.description = [abstract, description].join('')
    contributors.each do |name|
      document.add_contributor(name: name)
    end

    unless document.valid?
      puts @document.inspect
      puts "Document is invalid"
      error_count += 1
      next
    end

    response = api.upload_record(document)
    if response.code != 202
      puts "Received code #{response.code}"
      puts response.body
      exit 1
    end
  end
end

puts "Finished. #{overall_record_count} records, #{error_count} errors"
