# Probably will mostly do some sort of translation to batch ingest tool
# For now it just manipulates a class variable
class OsfIngestWorker
  def self.create_osf_job(archive, queue: default_queue)
    # Do something with the Admin::IngestOSFArchive object
    worker = new(archive.as_hash)
    queue.push(worker)
  end

  def self.default_queue
    Sufia.queue
  end

  attr_reader :archive
  def initialize(attributes = {})
    @archive = Admin::IngestOSFArchive.new(attributes)
  end

  def run
    BatchIngestor.start_osf_archive_ingest(archive.as_hash)
  end
end
