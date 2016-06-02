module Bendo
  # Refresh the cache of an item stored in Bendo
  class RefreshCacheController < BendoController

    # Provide a human-friendly refresh process
    def recall_item
      respond_to do |format|
        format.html
      end
    end

    # JSON API requests only
    def request_item
      respond_to do |format|
        format.json { render json: make_request(params[:id]) }
      end
    end

    private

    def make_request(id)
      JSON.generate({id.to_sym => true})
    end
  end
end
