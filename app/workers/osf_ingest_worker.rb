# Probably will mostly do some sort of translation to batch ingest tool
# For now it just manipulates a class variable
class OsfIngestWorker
  def self.create_osf_job(archive)
    # Do something with the Admin::IngestOSFArchive object
    @@archive_array ||= []
    @@archive_array.push(archive)
  end
end
