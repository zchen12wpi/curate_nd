module Bendo
  # Refresh the cache of an item stored in Bendo
  class RefreshCacheController < BendoController

    # Provide a human-friendly refresh process
    def recall_item
      if item
        respond_to do |format|
          format.html { render 'recall_item', status: 302 }
          format.json { render json: api_response, status: 302 }
        end
      else
        respond_to do |format|
          format.html { render 'item_not_found', status: 404 }
          format.json { render json: api_response, status: 404 }
        end
      end
    end

    # JSON API requests only
    def request_item
      respond_to do |format|
        format.json { render json: api_response }
      end
    end

    private

    def item
      begin
        @item ||= ActiveFedora::Base.find(params[:id], cast: true)
      rescue ActiveFedora::ObjectNotFoundError
        @item = nil
      end
    end
    helper_method :item

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
