class Admin::FixityController < ApplicationController
  with_themed_layout('1_column')

  def index
    results = Bendo::Services::FixityChecks.call(params: clean_params)

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

  def clean_params
    params.permit(:item, :status, :scheduled_time_start, :scheduled_time_end )
      .delete_if { |k, v| v.nil? || v.empty? }
  end
end
