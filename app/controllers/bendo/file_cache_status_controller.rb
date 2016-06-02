module Bendo
  # Pass file cache status requests along to Bendo
  class FileCacheStatusController < BendoController
    layout false
    respond_to :json

    def check
      render json: api_response.body, status: api_response.status
    end

    private

    def api_response
      @response ||= make_request(params[:id])
    end
    helper_method :api_response

    def make_request(id)
      Bendo::Services::RefreshFileCache.call(
        id: id,
        handler: Bendo::Services::FakeApi
      )
    end
  end
end
