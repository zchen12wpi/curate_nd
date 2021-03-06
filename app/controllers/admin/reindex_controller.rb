require 'json'

module Admin
  class ReindexController < ApplicationController
    with_themed_layout("1_column")

    skip_before_action :verify_authenticity_token

    # POST /admin/reindex
    def reindex
      json = get_json_array(request.body.read)
      if json.nil?
        head 400
        return
      end
      reindexer = Admin::Reindex.new(json)
      reindexer.add_to_work_queue
      head :ok
    end

    def reindex_pid
      reindexer = Admin::Reindex.new([params[:id]])
      reindexer.add_to_work_queue
      flash[:notice] = "Successfully add to reindex queue for '#{params[:id]}'."
      redirect_to(request.env["HTTP_REFERER"] || catalog_index_path)
    end

    private

    # try to parse a json array out of input
    # returns the array if valid, otherwise returns nil
    def get_json_array(input)
      json = JSON.parse(input)
      return nil unless json.is_a?(Array)
      json
    rescue JSON::ParserError
      return nil
    end
  end
end
