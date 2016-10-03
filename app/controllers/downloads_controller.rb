require 'sufia/models/noid'

class DownloadsController < ApplicationController
  include Sufia::Noid # for normalize_identifier method
  include Hydra::Controller::DownloadBehavior
  include Hydra::AccessControls
  prepend_before_filter :normalize_identifier, except: [:index, :new, :create]
  with_themed_layout

  rescue_from Hydra::AccessDenied, with: :handle_access_denied

  def datastream_to_show
    super
  rescue Exception => e
    if params[:datastream_id] == 'thumbnail'
      respond_with_default_thumbnail_image
      return false
    else
      raise e
    end
  end

  protected

  def render_404
    if params[:datastream_id] == 'thumbnail'
      respond_with_default_thumbnail_image
    else
      render '/errors/404'
    end
  end

  # Send default thumbnail image
  def respond_with_default_thumbnail_image
    image= ActionController::Base.helpers.asset_path("curate/default.png", type: :image)
    redirect_to image
  end

  def content_options
    options = {
      disposition: 'inline',
      type: datastream.mimeType,
      filename: datastream_name
    }
    options[:disposition] = 'attachment' if options[:type] =~ /\/xml/i
    options
  end

  def send_content(asset)
    # Disadis is configured to send only content datastreams. Don suggested that
    # we leave thumbnails to the application for the time being.
    if download_proxying_enabled? && !thumbnail_datastream?
      response.headers['X-Accel-Redirect'] = "/download-content/#{asset.noid}"
      head :ok
    else
      response.headers['Accept-Ranges'] = 'bytes'

      if head_request?
        content_head
      elsif range_request?
        send_range
      else
        if redirect_datastream?
          redirect_to datastream.dsLocation
        else
          send_file_headers! content_options
          self.response_body = datastream.stream
        end
      end
    end
  end

  private

  def can_download?
    if params[:token] && TemporaryAccessToken.permitted?(Sufia::Noid.noidify(params[:id]), params[:token])
      TemporaryAccessToken.use!(params[:token])
      true
    else
      super
    end
  end

  def download_proxying_enabled?
    Rails.application.config.use_proxy_for_download.enabled?
  end

  def handle_access_denied
    if thumbnail_datastream?
      asset = load_asset
      if can_download_thumnail?(asset)
        send_content (asset)
      else
        respond_with_default_thumbnail_image
        return false
      end
    else
      if current_user
        error_code = '403'
      else
        error_code = '401'
      end
      respond_to do |format|
        format.json { render json: { status: 'ERROR', code: error_code } }
        format.html { render "/errors/#{error_code}", status: error_code }
      end
    end
  end

  def head_request?
    request.head?
  end

  def range_request?
    request.headers['HTTP_RANGE']
  end

  def redirect_datastream?
    datastream.redirect?
  end

  def redirect_url
    datastream.dsLocation
  end

  def thumbnail_datastream?
    params[:datastream_id] == 'thumbnail'
  end

  def can_download_thumnail?(asset)
    return nd_only_datastream? && (can? :read, asset.parent.pid)
  end

  def nd_only_datastream?
    permissions = current_ability.permissions_doc(params[:id])
    access_key = ActiveFedora::SolrService.solr_name("read_access_group", Hydra::Datastream::RightsMetadata.indexer)
    return permissions[access_key].present? && permissions[access_key].first.downcase == "registered"
  end





end
