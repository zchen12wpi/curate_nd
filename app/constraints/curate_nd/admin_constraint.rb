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
      Admin::AuthorityGroup::RepositoryAdministrator.new.usernames.include?(username)
    end
  end
end
