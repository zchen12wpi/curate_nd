# Provides a simple API for retrieving ids of users who are permitted to act as
# a repository administrator.
module Admin
  class AuthorityGroup
    class RepositoryAdministrator < Admin::AuthorityGroup
      attr_accessor :authority_group, :usernames
      AUTH_GROUP_NAME = 'admin'

      def initialize
        @authority_group = Admin::AuthorityGroup.authority_group_for(auth_group_name: AUTH_GROUP_NAME) || Admin::AuthorityGroup.new
        @usernames = (authority_group.usernames + super_admin_users).uniq
      end

      def self.initialize_usernames
        load_usernames(usernames_file: 'config/admin_usernames.yml',
                       file_key: 'admin_usernames')
      end

      def super_admin_users
        Admin::AuthorityGroup::SuperAdmin.new.usernames
      end
    end
  end
end
