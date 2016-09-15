# Probably will mostly do some sort of translation to batch ingest tool
# For now it just manipulates a class variable
class OsfIngestWorker
  def self.create_osf_job(archive, queue: default_queue)
    # I prefer to push a primitive object into the queue. It ensures that there are not state
    # mutations between enqueuing and dequeuing; This is important when dealing with an ActiveRecord object
    worker = new(archive.as_hash)
    queue.push(worker)
  end

  def self.default_queue
    Sufia.queue
  end

  attr_reader :attributes
  def initialize(attributes = {})
    @attributes = attributes
  end

  def run
    BatchIngestor.start_osf_archive_ingest(attributes)
  rescue StandardError => exception
    Airbrake.notify_or_ignore(
      error_class: exception.class, error_message: exception, parameters: { OsfIngestWorker_attributes: attributes }
    )
    raise exception
  end
end
