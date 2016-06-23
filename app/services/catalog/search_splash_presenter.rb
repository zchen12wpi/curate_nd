module Catalog
  module SearchSplashPresenter
    ARTICLE_SPLASH = 'Articles & Publications'.freeze
    DATASET_SPLASH = 'Datasets & Related Materials'.freeze
        ETD_SPLASH = 'Theses & Dissertations'.freeze

    def call(params)
      if category_present?(params)
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
    module_function :call

    private

    module_function

    def category_key
      :human_readable_type_sim
    end

    def category_present?(params)
      params.key?(:f) && params[:f].fetch(category_key, nil)
    end

    def category_match?(params, value)
      params[:f][category_key] == value
    end

    def inclusive_category_present?(params)
      params.key?(:f_inclusive) && params[:f_inclusive].fetch(category_key, nil)
    end

    def inclusive_category_match?(params, value)
      params[:f_inclusive][category_key] == value
    end

  end
end
