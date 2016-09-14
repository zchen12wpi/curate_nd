class Admin::BatchIngestController < ApplicationController
  with_themed_layout('1_column')

  def index
    @name_filter = params[:name_filter]
    @status_filter = params[:status_filter]
    name_regex = @name_filter.present? ? Regexp.new(@name_filter) : /.*/
    status_regex = @status_filter.present? ? Regexp.new(@status_filter) : /.*/
    @jobs = BatchIngestor.new.get_jobs({ name: name_regex, status: status_regex })
  end
end
