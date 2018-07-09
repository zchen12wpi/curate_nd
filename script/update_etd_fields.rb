require 'json'
# Make sure a file is given
if ARGV.length < 1
  puts "ERROR: No File listed in command
  usage: update_empty_etd_fields.rb update_info.json

  json example:
  [
    {
      'work_id': '00000001a1',
      'catalog_system_number': '000000000',
      'ETD_REVIEWER_SIGNOFF_DATE': '2010-01-01',
      'oclc_number': 000000000
    }
  ]"
  exit 2
end
# Read JSON file
puts 'Reading JSON File'
filename = ARGV[0]
file_content = File.read(filename)
data = JSON.parse(file_content)

# typemap = {
#   'work_id' => 'pid',
#   'catalog_system_number' => 'alephIdentifier',
#   'ETD_REVIEWER_SIGNOFF_DATE' => 'date_approved',
#   'oclc_number' => 'urn'
# }

data.each do |record|
# Check if the record exists in CurateND
  puts "checking record #{record['work_id']}"
  # next puts "no record found, continuing to next record" unless Etd.exists?(record['work_id'])
  begin
    etd = Etd.find('und:'+record['work_id'])
  rescue
    next puts "no record found, continuing to next record"
  end
  record_updated = false
# Check if the record has the attributes set
  unless record['catalog_system_number'].nil?
    etd.alephIdentifier = record['catalog_system_number']
    record_updated = true
    puts "new record found"
  end
  unless record['ETD_REVIEWER_SIGNOFF_DATE'].nil?
    etd.date_approved = record['ETD_REVIEWER_SIGNOFF_DATE']
    record_updated = true
    puts "new record found"
  end
  unless record['oclc_number'].nil?
    etd.urn = record['oclc_number']
    record_updated = true
    puts "new record found"
  end
# Save etd if any records updated
  if record_updated
    begin
      puts "saving record"
      etd.save!
      puts "record saved"
    rescue
      puts "record #{record['work_id']} failed to save"
    end
  end
end
