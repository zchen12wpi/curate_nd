require 'uri'
require 'psych'

module Bendo
  module_function

  def config
    @@config ||= Psych.load(ERB.new(IO.read(Rails.root.join('config/bendo.yml'))).result).fetch(Rails.env)
  end

  def url
    @@url ||= config.fetch('url')
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

  def fixity_url()
    File.join(url, '/fixity')
  end

  def api_key()
    @@api_key ||= config.fetch('api_key')
  end
end
