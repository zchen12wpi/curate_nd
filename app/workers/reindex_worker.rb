class ReindexWorker
  def queue_name
    :resolrize
  end

  attr_reader :pids_to_reindex

  def initialize(pid_list = nil)
    @pids_to_reindex = pid_list.nil? ? :everything : Array.wrap(pid_list)
  end

  def run
    if @pids_to_reindex == :everything
      ActiveFedora::Base.reindex_everything("pid~#{Sufia.config.id_namespace}:*")
    else
      @pids_to_reindex.each do |pid|
        ActiveFedora::Base.find(pid, cast: true).update_index
      end
    end
  end
end
