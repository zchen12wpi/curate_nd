require 'catalog/collection_decorator'
require 'catalog/hierarchical_term_label'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/array/wrap'

module Catalog
  module SearchSplashPresenter
    ARTICLE_SPLASH = 'Articles & Publications'.freeze
    DATASET_SPLASH = 'Datasets & Related Materials'.freeze
        ETD_SPLASH = 'Theses & Dissertations'.freeze

    def self.call(params, title_decorator: TitleDecorator, collection_decorator: CollectionDecorator)
      if exactly_one_department?(params)
        title_decorator.call(department_label(params))
      elsif exactly_one_collection?(params)
        collection_decorator.call(collection_label(params))
      elsif category_present?(params)
        if category_match?(params, ['Article'])
          title_decorator.call(ARTICLE_SPLASH)
        elsif category_match?(params, ['Dataset'])
          title_decorator.call(DATASET_SPLASH)
        end
      elsif inclusive_category_present?(params)
        if inclusive_category_match?(
          params,
          [
            'Doctoral Dissertation',
            "Master's Thesis"
          ])
          title_decorator.call(ETD_SPLASH)
        end
      else
        title_decorator.call(nil)
      end
    end

    def self.department_key
      :admin_unit_hierarchy_sim
    end

    def self.collection_key
      # see Curate::LibraryCollectionIndexingAdapter::SOLR_KEY_PATHNAME_HIERARCHY_WITH_TITLES_FACETABLE
      :library_collections_pathnames_hierarchy_with_titles_sim
    end

    def self.category_key
      :human_readable_type_sim
    end

    module TitleDecorator
      TitleStruct = Struct.new(:title)

      def self.call(attribute)
        TitleStruct.new(attribute)
      end
    end

    def self.exactly_one_department?(params)
      return false unless params.key?(:f) && params[:f][department_key].present?
      Array.wrap(params[:f][department_key]).count == 1
    end
    private_class_method :exactly_one_department?

    def self.department_label(params)
      term = Array.wrap(params[:f][department_key]).first
      Catalog::HierarchicalTermLabel::SimpleMapper.call(term)
    end
    private_class_method :department_label

    def self.exactly_one_collection?(params)
      return false unless params.key?(:f) && params[:f][collection_key].present?
      Array.wrap(params[:f][collection_key]).count == 1
    end
    private_class_method :exactly_one_collection?

    def self.collection_label(params)
      Array.wrap(params[:f][collection_key]).first
    end
    private_class_method :collection_label

    def self.category_present?(params)
      params.key?(:f) && params[:f][category_key].present?
    end
    private_class_method :category_present?

    def self.category_match?(params, value)
      params[:f][category_key] == value
    end
    private_class_method :category_match?

    def self.inclusive_category_present?(params)
      params.key?(:f_inclusive) && params[:f_inclusive][category_key].present?
    end
    private_class_method :inclusive_category_present?

    def self.inclusive_category_match?(params, value)
      params[:f_inclusive][category_key] == value
    end
    private_class_method :inclusive_category_match?
  end
end
