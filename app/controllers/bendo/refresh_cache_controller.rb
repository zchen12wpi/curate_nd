module Bendo
  # Refresh the cache of an item stored in Bendo
  class RefreshCacheController < BendoController
    include Sufia::Noid
    before_filter :normalize_identifier
    layout 'common_objects'

    # Provide a human-friendly refresh process
    def recall_item
      if item
        respond_to do |format|
          format.html { render 'recall_item', status: 302 }
          format.json { render(
            json: api_response.body,
            status: api_response.status
          )}
        end
      else
        respond_to do |format|
          format.html { render 'item_not_found', status: 404 }
          format.json { render(
            json: {},
            status: 404
          )}
        end
      end
    end

    # JSON API requests only
    def request_item
      respond_to do |format|
        format.json { render(
          json: api_response.body,
          status: api_response.status
        )}
      end
    end

    private

    def item
      begin
        @item ||= ActiveFedora::Base.find(params[:id], cast: true)
      rescue ActiveFedora::ObjectNotFoundError
        @item = nil
      end

      @item = nil unless @item.is_a? GenericFile
    end
    helper_method :item

    def pid
      params[:id]
    end
    helper_method :pid

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
