class ReindexWorker
  def queue_name
    :resolrize
  end

  def run
    ActiveFedora::Base.reindex_everything("pid~#{Sufia.config.id_namespace}:*")
  end
end
