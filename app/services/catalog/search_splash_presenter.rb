module Catalog
  module SearchSplashPresenter
    ARTICLE_SPLASH = 'Articles & Publications'.freeze
    DATASET_SPLASH = 'Datasets & Related Materials'.freeze
        ETD_SPLASH = 'Theses & Dissertations'.freeze

    # NOTE: terms are encoded with '::' as a delimeter but are indexed with ':'
    DEPARTMENT_LABEL_MAP = {
      'University of Notre Dame:College of Arts and Letters:Non-Departmental' => 'College of Arts and Letters, Non-Departmental',
      'University of Notre Dame:Mendoza College of Business:Non-Departmental' => 'Mendoza College of Business, Non-Departmental',
      'University of Notre Dame:College of Engineering:Non-Departmental' => 'Engineering, Non-Departmental',
      'University of Notre Dame:College of Science:Non-Departmental' => 'College of Science, Non-Departmental',
      'University of Notre Dame:Reserve Officers Training Corps:Non-Departmental' => 'ROTC, Non-Departmental',
      'University of Notre Dame:Hesburgh Libraries:General' => 'Hesburgh Libraries General Collection'
    }

    module_function

    def call(params)
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

    def department_key
      :admin_unit_hierarchy_sim
    end

    def category_key
      :human_readable_type_sim
    end

    private

    module_function

    def exactly_one_department(params)
      return false unless params.key?(:f) && params[:f].fetch(department_key, nil)
      params[:f][department_key].count == 1
    end

    def department_label(params)
      term = params[:f][department_key].first
      DEPARTMENT_LABEL_MAP.fetch(term, term.split(':').last)
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
