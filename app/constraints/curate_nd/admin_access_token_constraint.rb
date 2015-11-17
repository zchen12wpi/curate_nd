module CurateND
  module AdminAccessTokenConstraint
    module_function

    def matches?(request)
      current_user = request.env.fetch('warden').user
      EtdManagers.include?(current_user)
    rescue KeyError, NoMethodError
      return false
    end
  end
end
