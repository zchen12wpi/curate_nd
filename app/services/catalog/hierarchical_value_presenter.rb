require 'CGI'

module Catalog
  module HierarchicalValuePresenter
    module_function

    def call(value: value, opener:'<p>', closer:'</p>', link: false)
      values = Array.wrap(value)
      if link
        decorator = :decorate_with_links
      else
        decorator = :decorate
      end

      values.map do |v|
        "#{opener}#{self.send(decorator, value: v)}#{closer}".html_safe
      end
    end

    def decorate_with_links(
      value: value,
      value_delimiter: '::',
      opener: '<span class="hierarchy">',
      closer: '</span>',
      path: '/catalog',
      param: 'f[admin_unit_hierarchy_sim][]',
      param_delimiter: ':'
    )
      levels = value.split(value_delimiter)
      markup = ''
      levels.each_with_index do |level, i|
        markup << opener
        value = CGI.escape("#{levels[0..i].join(param_delimiter)}")
        query = CGI.escape(param)
        markup << "<a href=\"#{path}?#{query}=#{value}\">#{level}</a>"
        markup << closer
      end
      markup
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
