require 'curate/indexer'

# Responsible for reindexing a single PID and its relationships
class ObjectRelationshipReindexerWorker
  def queue_name
    :resolrize
  end

  def initialize(pid)
    @pid = pid
  end
  attr_reader :pid

  def run
    begin
      Curate::Indexer.reindex_relationships(pid)
    rescue StandardError => exception
      Airbrake.notify_or_ignore(error_class: exception.class, error_message: exception, parameters: {})
      raise exception
    end
  end
end
