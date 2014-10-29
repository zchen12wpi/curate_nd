# Turn a list of identifiers into a batch
# of Jobs to reindex those identifiers.
# Each Job will have no more than 10 identifiers.
module Admin
  class Reindex
    def initialize(pid_list)
      @pid_list = pid_list
    end

    def add_to_work_queue
      until @pid_list.empty?
        batch = @pid_list.slice!(0, 10)
        Sufia.queue.push(ReindexWorker.new(batch))
      end
    end
  end
end
