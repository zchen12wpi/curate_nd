class Admin::BatchIngestController < ApplicationController
  with_themed_layout('1_column')

  def index
    @jobs = BatchIngestTools.get_jobs
  end
end
