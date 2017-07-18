module Catalog
  module ConstraintPresenter
    module ProxyDecorator
      def self.call(value)
        sanitized = ActionView::Base.white_list_sanitizer.sanitize(value, {})
        ERB::Util.html_escape(sanitized).try(:html_safe)
      end
    end

    # Because this is called within a view context we it keys off a CSS class. ☹
    CONSTRAINT_CLASS_PRESENTER_MAP = Hash.new(ProxyDecorator).merge(
      'filter-admin_unit_hierarchy_sim' => HierarchicalTermLabel::SimpleMapper,
      'filter-library_collections_pathnames_hierarchy_with_titles_sim' => HierarchicalTermLabel::TitleExtractor
    )

    def self.call(value: value, options: options)
      if options[:classes].any? && options[:classes].last.present?
        key = options[:classes].last
        CONSTRAINT_CLASS_PRESENTER_MAP[key].call(value)
      else
        ProxyDecorator.call(value)
      end
    end
  end
end
