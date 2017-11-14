require 'catalog/collection_decorator'

module Catalog
  module HierarchicalTermLabel
    module SimpleMapper
      # NOTE: terms are encoded with '::' as a delimeter but are indexed with ':'
      DEPARTMENT_LABEL_MAP = {
        'University of Notre Dame:College of Arts and Letters:Non-Departmental' => 'College of Arts and Letters, Non-Departmental',
        'University of Notre Dame:Mendoza College of Business:Non-Departmental' => 'Mendoza College of Business, Non-Departmental',
        'University of Notre Dame:College of Engineering:Non-Departmental' => 'Engineering, Non-Departmental',
        'University of Notre Dame:College of Science:Non-Departmental' => 'College of Science, Non-Departmental',
        'University of Notre Dame:Reserve Officers Training Corps:Non-Departmental' => 'ROTC, Non-Departmental',
        'University of Notre Dame:Hesburgh Libraries:General' => 'Hesburgh Libraries General Collection'
      }

      # @note I'm checking Hash in this case as the tests are very fast (and I don't want to load ActionController::Parameters for those tests)
      # @see ./lib/curate/action_controller-parameters_spec.rb for assertion that ActionController::Parameters is a Hash
      # @see https://github.com/ndlib/curate_nd/commit/67b95db10ce73809d04bcbb71a7afa5910e22a9f for related update
      # @see ./app/services/catalog/collection_decorator.rb for related change
      def self.call(value, term: :department)
        value = value.is_a?(Hash) ? value.values.first : value
        values_for(term).fetch(value) { fallback(value) }
      end

      def self.values_for(term)
        map_name = "#{term.to_s.upcase}_LABEL_MAP"
        if self.const_defined?(map_name)
          self.const_get(map_name)
        else
          {}
        end
      end
      private_class_method :values_for

      def self.fallback(value)
        value.split(':').last
      end
      private_class_method :fallback
    end

    module TitleExtractor
      def self.call(value)
        Catalog::CollectionDecorator.title_from_scope(value)
      end
    end
  end
end
