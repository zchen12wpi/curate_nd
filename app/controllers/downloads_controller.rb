require Curate::Engine.root.join("app/controllers/downloads_controller")
class DownloadsController
  protected

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
        super
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

  def thumbnail_datastream?
    params[:datastream_id] == 'thumbnail'
  end
end
