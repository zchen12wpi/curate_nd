module Catalog
  module ConstraintPresenter
    def self.call(value: value, options: options, decorator: HierarchicalTermLabel)
      if hierarchical_value?(options)
        decorator.send(:call, value)
      else
        value
      end
    end

    def self.hierarchical_value?(options)
      if options[:classes].any? && options[:classes].last.present?
        options[:classes].last == 'filter-admin_unit_hierarchy_sim'
      else
        false
      end
    end
    private_class_method :hierarchical_value?
  end
end
