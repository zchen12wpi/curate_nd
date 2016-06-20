module Catalog
  module ConstraintPresenter
    module_function

    def call(value: value, options: options)
      if hierarchical_value?(options)
        decorate(value)
      else
        value
      end
    end

    def hierarchical_value?(options)
      if options[:classes].any? && options[:classes].last.present?
        options[:classes].last == 'filter-admin_unit_hierarchy_sim'
      else
        false
      end
    end

    def decorate(value)
      levels = value.split(':')
      opener = '<span class="hierarchy">'
      closer = '</span>'
      markup = opener
      markup << levels.join("#{closer}#{opener}")
      markup << closer
      markup
    end
  end
end
