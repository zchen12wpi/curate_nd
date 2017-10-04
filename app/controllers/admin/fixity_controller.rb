class Admin::FixityController < ApplicationController
  with_themed_layout('1_column')

  def index
    params.delete_if { |k, v| v.nil? || v.empty? }
    results = Bendo::Services::FixityChecks.call(params: params)

    if results.status === 200
      @fixity_results = results.body
    else
      @fixity_results = []
    end

    respond_to do |format|
      format.html do
        flash[:error] = "Something went wrong when retrieving records from Bendo." unless results.status === 200
      end

      format.json do
        render json: @fixity_results, status: results.status
      end
    end
  end
end
