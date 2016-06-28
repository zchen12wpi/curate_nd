require 'uri'
require 'psych'

module Bendo
  module_function

  def url
    @@url ||= Psych.load(ERB.new(IO.read(Rails.root.join('config/bendo.yml'))).result).fetch(Rails.env).fetch('url')
  end

  def item_path(slug)
    if slug =~ /^\/?item/
      File.join('/', slug)
    else
      File.join('/item', slug)
    end
  end

  def item_url(slug)
    File.join(url, item_path(slug))
  end
end
