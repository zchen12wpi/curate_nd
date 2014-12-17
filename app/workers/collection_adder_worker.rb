class CollectionAdderWorker
  def queue_name
    :collection_adder
  end

  class Error < RuntimeError
    attr_reader :error_msg, :pid
    def initialize(error_msg, pid)
      @error_msg = error_msg
      @pid = pid
    end
  end

  attr_reader :target_collection_pid
  attr_reader :pids_to_add

  # duplicate pids in the pid_list are okay...the duplicates will be removed
  def initialize(target_collection_pid, pid_list)
    @target_collection_pid = target_collection_pid
    @pids_to_add = pid_list.uniq
  end

  def run
    # this will raise an error if the collection does not exist
    collection = ActiveFedora::Base.find(target_collection_pid, cast: true)
    if !collection.is_a?(Collection)
      raise Error.new("Item is not a collection", target_collection_pid)
    end
    members = collection.members.map(&:pid)
    pids_to_add.each do |pid|
      next if members.include?(pid)
      item = ActiveFedora::Base.find(pid, cast: true)
      collection.add_member(item)
    end
  end
end
