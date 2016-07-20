require 'catalog/hierarchical_term_label'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/array/wrap'
require 'ostruct'

module Catalog
  module SearchSplashPresenter
    ARTICLE_SPLASH = 'Articles & Publications'.freeze
    DATASET_SPLASH = 'Datasets & Related Materials'.freeze
        ETD_SPLASH = 'Theses & Dissertations'.freeze

    def self.call(params)
      attributes = case
      when exactly_one_department?(params)
        { title: department_label(params) }
      when exactly_one_collection?(params)
        { title: collection_label(params) }
      when category_present?(params)
        if category_match?(params, ['Article'])
          { title: ARTICLE_SPLASH }
        elsif category_match?(params, ['Dataset'])
          { title: DATASET_SPLASH }
        end
      when inclusive_category_present?(params)
        if inclusive_category_match?(
          params,
          [
            'Doctoral Dissertation',
            "Master's Thesis"
          ])
          { title: ETD_SPLASH }
        end
      else
        nil
      end

      OpenStruct.new(attributes)
    end

    def self.department_key
      :admin_unit_hierarchy_sim
    end

    def self.collection_key
      :library_collections_sim
    end

    def self.category_key
      :human_readable_type_sim
    end

    def self.exactly_one_department?(params)
      return false unless params.key?(:f) && params[:f][department_key].present?
      Array.wrap(params[:f][department_key]).count == 1
    end
    private_class_method :exactly_one_department?

    def self.department_label(params)
      term = Array.wrap(params[:f][department_key]).first
      Catalog::HierarchicalTermLabel.call(term)
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
