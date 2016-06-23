module Catalog
  module ConstraintPresenter
    module_function

    def call(value: value, options: options, decorator: HierarchicalValuePresenter)
      if hierarchical_value?(options)
        decorator.send(:decorate, value: value, delimiter: ':')
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
  end
end
