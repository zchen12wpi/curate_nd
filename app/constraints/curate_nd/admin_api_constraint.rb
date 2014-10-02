module CurateND
  module AdminAPIConstraint
    module_function
    def matches?(request)
      key = request.headers['Curate-Api-Key']
      admin_keys.include?(key)
    rescue KeyError, NoMethodError
      return false
    end

    def admin_keys
      @admin_keys ||= YAML.load_file(Rails.root.join('config/admin_api_keys.yml'))[Rails.env].map(&:to_s)
    end
  end
end
