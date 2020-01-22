# Provides a simple API for retrieving ids of users who are permitted to
# administer the site authority
module Admin
  class AuthorityGroup
    class SuperAdmin < Admin::AuthorityGroup
      attr_accessor :authority_group, :usernames
      AUTH_GROUP_NAME = 'super_admin'

      def initialize
        @authority_group = Admin::AuthorityGroup.authority_group_for(auth_group_name: AUTH_GROUP_NAME) || Admin::AuthorityGroup.new
        @usernames = authority_group.usernames
      end

      def self.initialize_usernames
        load_usernames(usernames_file: 'config/admin_usernames.yml',
                       file_key: 'admin_usernames')
      end
    end
  end
end
