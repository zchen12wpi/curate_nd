require 'catalog/hierarchical_term_label'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/array/wrap'

module Catalog
  module SearchSplashPresenter
    ARTICLE_SPLASH = 'Articles & Publications'.freeze
    DATASET_SPLASH = 'Datasets & Related Materials'.freeze
        ETD_SPLASH = 'Theses & Dissertations'.freeze

    def self.call(params)
      if exactly_one_department(params)
        department_label(params)
      elsif category_present?(params)
        if category_match?(params, ['Article'])
          ARTICLE_SPLASH
        elsif category_match?(params, ['Dataset'])
          DATASET_SPLASH
        end
      elsif inclusive_category_present?(params)
        if inclusive_category_match?(
          params,
          [
            'Doctoral Dissertation',
            "Master's Thesis"
          ])
          ETD_SPLASH
        end
      else
        nil
      end
    end

    def self.department_key
      :admin_unit_hierarchy_sim
    end

    def self.category_key
      :human_readable_type_sim
    end

    def self.exactly_one_department(params)
      return false unless params.key?(:f) && params[:f][department_key].present?
      Array.wrap(params[:f][department_key]).count == 1
    end
    private_class_method :exactly_one_department

    def self.department_label(params)
      term = Array.wrap(params[:f][department_key]).first
      Catalog::HierarchicalTermLabel.call(term)
    end
    private_class_method :department_label

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
