module Catalog
  module SearchSplashPresenter
    module_function

    def call(params)
      category_key = :human_readable_type_sim

      if params.include?(:f) && params[:f][category_key]
        categories = params[:f][category_key]

        if categories.present? && categories.count == 1
          category = categories.first
        else
          category = nil
        end
      else
        category = nil
      end

      splash = case category
      when 'Article'
        'Articles & Publications'
      when 'Dataset'
        'Datasets & Related Materials'
      when 'Thesis or Dissertation', "Master's Thesis", 'Doctoral Dissertation'
        'Theses & Dissertations'
      else
        nil
      end

      splash
    end
  end
end
