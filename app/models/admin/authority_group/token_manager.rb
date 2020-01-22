# Provides a simple API for retrieving ids of users who are permitted to
# view but not edit everything on the site
module Admin
  class AuthorityGroup
    class TokenManager < Admin::AuthorityGroup
      attr_accessor :authority_group, :usernames
      AUTH_GROUP_NAME = 'token_managers'

      def initialize
        @authority_group = Admin::AuthorityGroup.authority_group_for(auth_group_name: AUTH_GROUP_NAME) || Admin::AuthorityGroup.new
        @usernames = authority_group.usernames
      end

      def self.initialize_usernames
        load_usernames(usernames_file: 'config/etd_manager_usernames.yml',
                       file_key: 'etd_manager_usernames')
      end
    end
  end
end
