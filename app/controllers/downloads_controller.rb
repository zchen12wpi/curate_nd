require 'sufia/models/noid'

class DownloadsController < ApplicationController
  include Sufia::Noid # for normalize_identifier method
  include Hydra::Controller::DownloadBehavior
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
      super
    end
  end

  # Send default thumbnail image
  def respond_with_default_thumbnail_image
    image= ActionController::Base.helpers.asset_path("curate/default.png", type: :image)
    redirect_to image
  end

  def send_content(asset)
    # Because we don't want to proxy thumbnails, as per Don's suggestion.
    if Rails.application.config.use_proxy_for_download.enabled? && !thumbnail_datastream?
      content_options
      response.headers['X-Accel-Redirect'] = "/download-content/#{asset.noid}"
      head :ok
    else
      if datastream.mimeType.eql?('application/xml')
        send_data datastream.content, type: "application/xml"
      else
        response.headers['Accept-Ranges'] = 'bytes'

        if request.head?
          content_head
        elsif request.headers['HTTP_RANGE']
          send_range
        else
          send_file_headers! content_options
          self.response_body = datastream.stream
        end
      end
    end
  end

  def content_options
    options = super
    options[:disposition] =
    case datastream.mimeType.to_s
    when /\/xml/i then "attachment"
    else "inline"
    end
    options
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

  def handle_access_denied
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

  def thumbnail_datastream?
    params[:datastream_id] == 'thumbnail'
  end

end
