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

    # JSON API requests & noscript fallback HTML responses
    def request_item
      if is_downloadable?
        if is_viewable?
          respond_to do |format|
            format.html do
              flash[:notice] = 'File retrieval request received.'
              redirect_to(
                recall_bendo_item_path(id: noid),
                status: :found
              )
            end
            format.json { json_api_response }
          end
        else
          respond_to do |format|
            format.html do
              flash[:alert] = "You are not permitted to view the item with ID: #{noid}"
              redirect_to recall_bendo_item_path(id: noid)
            end
            format.json { json_unauthorized_response }
          end
        end
      else
        respond_to do |format|
          format.html do
            flash[:alert] = "No files can be downloaded for ID: #{noid}"
            redirect_to recall_bendo_item_path(id: noid)
          end
          format.json { json_not_found_response }
        end
      end
    end

    def pid
      @pid ||= Sufia::Noid.namespaceize(params[:id])
    end

    def noid
      @noid ||= Sufia::Noid.noidify(params[:id])
    end
    helper_method :noid

    def item_slug
      @item_slug ||= find_item_slug
    end
    helper_method :item_slug

    private

    def is_downloadable?
      item.is_a? GenericFile
    end

    def is_viewable?
      can?(:show, item)
    end

    def item
      @item ||= ActiveFedora::Base.find(pid, cast: true)
    end
    alias_method :curation_concern, :item
    helper_method :item, :curation_concern

    def find_item_slug
      content = item.datastreams.fetch('content')
      bendo_datastream = Bendo::DatastreamPresenter.new(datastream: content)
      bendo_datastream.item_slug
    end

    def api_response
      @response ||= make_request
    end
    helper_method :api_response

    def make_request
      Bendo::Services::RefreshFileCache.call(
        item_slugs: item_slug
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
        json: { item_slug => 401 },
        status: :unauthorized
      )
    end

    def json_not_found_response
      render(
        json: { item_slug => 404 },
        status: :not_found
      )
    end

  end
end
