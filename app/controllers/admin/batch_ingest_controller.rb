class Admin::BatchIngestController < ApplicationController
  with_themed_layout('1_column')

  def index
    name_regex = params[:name_filter].present? ? Regexp.new(params[:name_filter]) : /.*/
    status_regex = params[:status_filter].present? ? Regexp.new(params[:status_filter]) : /.*/
    @jobs = BatchIngestor.get_jobs({ name: name_regex, status: status_regex })
  end
end
