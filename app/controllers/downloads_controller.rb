require Curate::Engine.root.join("app/controllers/downloads_controller")
class DownloadsController
  protected

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
