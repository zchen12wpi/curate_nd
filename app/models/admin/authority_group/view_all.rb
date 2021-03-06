# Provides a simple API for retrieving ids of users who are permitted to
# view but not edit everything on the site
module Admin
  class AuthorityGroup
    class ViewAll< Admin::AuthorityGroup
      attr_accessor :authority_group, :usernames
      AUTH_GROUP_NAME = 'view_all'

      def initialize
        @authority_group = Admin::AuthorityGroup.authority_group_for(auth_group_name: AUTH_GROUP_NAME) || Admin::AuthorityGroup.new
        @usernames = authority_group.usernames
      end


      def self.initialize_usernames
        []
      end
    end
  end
end
