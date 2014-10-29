require Curate::Engine.root.join("app/controllers/downloads_controller")
class DownloadsController
  protected

  def send_content(asset)
    if Rails.application.config.use_proxy_for_download.enabled? && !params[:datastream_id].present?
      content_options
      response.headers['X-Accel-Redirect'] = "/download-content/#{asset.noid}"
      head :ok
    else
      super
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
end
