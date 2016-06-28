module Catalog
  module HierarchicalTermLabel
    # NOTE: terms are encoded with '::' as a delimeter but are indexed with ':'
    DEPARTMENT_LABEL_MAP = {
      'University of Notre Dame:College of Arts and Letters:Non-Departmental' => 'College of Arts and Letters, Non-Departmental',
      'University of Notre Dame:Mendoza College of Business:Non-Departmental' => 'Mendoza College of Business, Non-Departmental',
      'University of Notre Dame:College of Engineering:Non-Departmental' => 'Engineering, Non-Departmental',
      'University of Notre Dame:College of Science:Non-Departmental' => 'College of Science, Non-Departmental',
      'University of Notre Dame:Reserve Officers Training Corps:Non-Departmental' => 'ROTC, Non-Departmental',
      'University of Notre Dame:Hesburgh Libraries:General' => 'Hesburgh Libraries General Collection'
    }

    def self.call(value, term: :department)
      values_for(term).fetch(value, fallback(value))
    end

    def self.values_for(term)
      map_name = "#{term.upcase}_LABEL_MAP"
      self.const_get(map_name)
    end
    private_class_method :values_for

    def self.fallback(value)
      value.split(':').last
    end
    private_class_method :fallback
  end
end
