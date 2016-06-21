module Catalog
  module HierarchicalValuePresenter
    module_function

    def call(value: value, opener:'<p>', closer:'</p>', link: false)
      values = Array.wrap(value)
      if link
        # TK
      else
        values.map do |v|
          "#{opener}#{decorate(value: v)}#{closer}".html_safe
        end
      end
    end

    def decorate(
      value: value,
      delimiter: '::',
      opener: '<span class="hierarchy">',
      closer: '</span>'
    )
      levels = value.split(delimiter)
      markup = opener
      markup << levels.join("#{closer}#{opener}")
      markup << closer
      markup
    end
  end
end
