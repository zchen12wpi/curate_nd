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
            format.html { render 'recall_item', status: :see_other }
            format.json { json_delegate_response }
          end
        else
          respond_to do |format|
            format.html { render unauthorized_path, status: :unauthorized }
            format.json { json_unauthorized_response }
          end
        end
      else
        respond_to do |format|
          format.html { render 'item_not_found', status: :not_found }
          format.json { json_not_found_response }
        end
      end
    end

    # JSON API requests only
    def request_item
      if is_downloadable?
        if is_viewable?
          respond_to do |format|
            format.html do
              flash[:notice] = "Request recieved. <a href=\"#{download_path(item.noid)}\">Click here to download the item.</a>".html_safe
              redirect_to(
                recall_bendo_item_path(pid),
                status: api_response.status
              )
            end
            format.json { json_api_response }
          end
        else
          respond_to do |format|
            format.html do
              flash[:alert] = "You are not permitted to view the item with ID: #{pid}"
              redirect_to recall_bendo_item_path(pid)
            end
            format.json { json_unauthorized_response }
          end
        end
      else
        respond_to do |format|
          format.html do
            flash[:alert] = "No files can be downloaded for ID: #{pid}"
            redirect_to recall_bendo_item_path(pid)
          end
          format.json { json_not_found_response }
        end
      end
    end

    def pid
      @pid ||= Sufia::Noid.namespaceize(params[:id])
    end
    helper_method :pid

    private

    def is_downloadable?
      item.is_a? GenericFile
    end

    def is_viewable?
      can?(:show, item)
    end

    def item
      begin
        @item ||= ActiveFedora::Base.find(pid, cast: true)
      rescue ActiveFedora::ObjectNotFoundError
        @item = nil
      end
    end
    alias_method :curation_concern, :item
    helper_method :item, :curation_concern

    def api_response
      @response ||= make_request(pid)
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

    def json_delegate_response
      render(
        json: {
          links: {
            self: common_object_path(noid),
            recall: request_bendo_cache_refresh_path(noid)
          },
          data: []
        },
        status: :ok
      )
    end

    def json_api_response
      render(
        json: api_response.body,
        status: api_response.status
      )
    end

    def json_unauthorized_response
      render(
        json: { pid => 401 },
        status: :unauthorized
      )
    end

    def json_not_found_response
      render(
        json: { pid => 404 },
        status: :not_found
      )
    end

  end
end
