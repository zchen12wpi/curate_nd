module CurateND
  module AdminConstraint

    module_function

    def matches?(request)
      current_user = request.env.fetch('warden').user
      is_admin?(current_user)
    rescue KeyError, NoMethodError
      return false
    end

    def is_admin?(user)
      username = user.respond_to?(:username) ? user.username : user.to_s
      !!admin_usernames.include?(username)
    end

    def admin_usernames
      @@admin_usernames ||= YAML.load(ERB.new(Rails.root.join('config/admin_usernames.yml').read).result)[Rails.env]['admin_usernames']
    end

  end
end
