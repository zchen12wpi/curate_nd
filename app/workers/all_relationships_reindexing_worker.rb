require 'curate/indexer'

# Responsible for reindexing a single PID and its relationships
class AllRelationshipsReindexerWorker
  def queue_name
    :resolrize
  end

  def run
    begin
      Curate::Indexer.reindex_all!
    rescue StandardError => exception
      Airbrake.notify_or_ignore(error_class: exception.class, error_message: exception, parameters: {})
      raise exception
    end
  end
end
