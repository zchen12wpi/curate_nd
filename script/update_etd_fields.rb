require 'json'
require 'logger'
# Start a log
@logger = Logger.new(STDOUT)
date_time = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
@logger = Logger.new("etd_update_#{date_time}.log")
@logger.level = Logger::DEBUG
@logger
# Make sure a file is given
if ARGV.length < 1
@logger.info "ERROR: No File listed in command
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
filename = ARGV[0]
@logger.info "Reading JSON File #{filename}"
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
  @logger.info "checking record #{record['work_id']}"
  # next @logger.info "no record found, continuing to next record" unless Etd.exists?(record['work_id'])
  begin
    etd = Etd.find('und:'+record['work_id'])
  rescue
    next @logger.info "no record found, continuing to next record"
  end
  record_updated = false
# Check if the record has the attributes set
  if record['catalog_system_number'].present? && etd.alephIdentifier.blank?
    etd.alephIdentifier = record['catalog_system_number']
    record_updated = true
    @logger.info "ALEPH ID #{etd.alephIdentifier} found for #{record['work_id']}"
  end
  if record['ETD_REVIEWER_SIGNOFF_DATE'].present? && etd.date_approved.blank?
    etd.date_approved = record['ETD_REVIEWER_SIGNOFF_DATE']
    record_updated = true
    @logger.info "Signoff Date #{etd.date_approved} found for #{record['work_id']}"
  end
  if record['oclc_number'].present? && etd.urn.blank?
    etd.urn = record['oclc_number']
    record_updated = true
    @logger.info "URN #{etd.urn} found found for #{record['work_id']}"
  end
# Save etd if any records updated
  if record_updated
    begin
      @logger.info "saving record #{record['work_id']}"
      etd.save!
      @logger.info "record #{record['work_id']} saved"
    rescue
      @logger.info "record #{record['work_id']} failed to save"
    end
  end
end
