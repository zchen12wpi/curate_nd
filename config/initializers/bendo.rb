require 'URI'

module Bendo
  module_function

  def url
    @@url ||= Psych.load_file(Rails.root.join('config/bendo.yml').to_s).fetch(Rails.env).fetch('url')
  end

  def item_url(slug)
    "#{url}#{slug}"
  end
end
