module Bendo
  # Refresh the cache of an item stored in Bendo
  class RefreshCacheController < BendoController
    include Sufia::Noid
    before_filter :normalize_identifier
    layout 'common_objects'

    # Provide a human-friendly refresh process
    def recall_item
      if is_downloadable?
        if is_viewable?
          respond_to do |format|
            format.html { render 'recall_item', status: 302 }
            format.json { render(
              json: api_response.body,
              status: api_response.status
            )}
          end
        else
          respond_to do |format|
            format.html { render unauthorized_path, status: :unauthorized }
            format.json { render(
              json: { pid => 401 },
              status: :unauthorized
            )}
          end
        end
      else
        respond_to do |format|
          format.html { render 'item_not_found', status: 404 }
          format.json { render(
            json: { pid => 404 },
            status: 404
          )}
        end
      end
    end

    # JSON API requests only
    def request_item
      if is_downloadable?
        if is_viewable?
          respond_to do |format|
            format.json { render(
              json: api_response.body,
              status: api_response.status
            )}
          end
        else
          respond_to do |format|
            format.json { render(
              json: { pid => 401 },
              status: :unauthorized
            )}
          end
        end
      else
        respond_to do |format|
          format.json { render(
            json: { pid => 404 },
            status: 404
          )}
        end
      end
    end

    private

    def is_downloadable?
      item.is_a? GenericFile
    end

    def is_viewable?
      can?(:show, item)
    end

    def item
      begin
        @item ||= ActiveFedora::Base.find(params[:id], cast: true)
      rescue ActiveFedora::ObjectNotFoundError
        @item = nil
      end
    end
    alias_method :curation_concern, :item
    helper_method :item, :curation_concern

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

    def unauthorized_path
      'app/views/curation_concern/base/unauthorized'
    end

  end
end
