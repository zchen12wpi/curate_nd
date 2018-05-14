require 'json'
require 'group_editor_pids_worker.rb'

module Admin
  class BatchEditController < ApplicationController
    skip_before_action :verify_authenticity_token
    def assign_group
      json = get_json_hash(request.body.read)
      if json.nil?
        head 400
        return
      end
      Sufia.queue.push(GroupEditorPIDsWorker.new(json.fetch("EditorPID"),json.fetch("PIDs")))
      respond_to do |format|
        format.json { render json: { message: 'Applying Editor permissions. Please hold.' } }
      end
    end
    def get_json_hash(input)
      json = JSON.parse(input)
      return nil unless json.is_a?(Hash)
      json
    rescue JSON::ParserError
      return nil
    end
  end
end
