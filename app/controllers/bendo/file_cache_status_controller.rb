module Bendo
  # Pass file cache status requests along to Bendo
  class FileCacheStatusController < BendoController
    layout false
    respond_to :json

    def check
      render json: api_response.body, status: api_response.status
    end

    private

    def item_slugs
      @item_slugs ||= params[:item_slugs]
    end

    def api_response
      @response ||= make_request
    end
    helper_method :api_response

    def make_request
      Bendo::Services::FileCacheStatus.call(
        item_slugs: item_slugs
      )
    end
  end
end
