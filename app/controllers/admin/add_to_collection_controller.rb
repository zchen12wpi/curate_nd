require 'json'

module Admin
  class AddToCollectionController < ApplicationController
    with_themed_layout("1_column")

    skip_before_action :verify_authenticity_token

    # POST /admin/add_to_collection
    def submit
      json = get_json_hash(request.body.read)
      if json.nil?
        head 400
        return
      end
      json.each do |collection_pid, item_pids|
        Sufia.queue.push(CollectionAdderWorker.new(collection_pid, item_pids))
      end
      head :ok
    end

    private

    # try to parse a json hash out of input
    # returns the hash if valid, otherwise returns nil
    # The hash should have the structure of
    # {
    #   "collection_1_pid": "single_pid",
    #   "collection_2_pid": ["list", "of", "pids"]
    # }
    # The pids will have the namespace prefix attached if there is not already
    # a namespace present
    def get_json_hash(input)
      json = JSON.parse(input)
      return nil unless json.is_a?(Hash)
      result = {}
      json.each do |collection_pid, pids|
        return nil unless [String, Array].include?(pids.class)
        pids = [pids] if pids.is_a?(String)
        pids = pids.map { |pid| normalize_pid(pid) }
        collection_pid = normalize_pid(collection_pid)
        result[collection_pid] = result.fetch(collection_pid, []) + pids
      end
      result
    rescue JSON::ParserError
      return nil
    end

    def normalize_pid(pid)
      if pid.index(":").nil?
        "#{Sufia.config.id_namespace}:#{pid}"
      else
        pid
      end
    end
  end
end
