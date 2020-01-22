module Admin
  class AuthorityGroup < ActiveRecord::Base
    validates :auth_group_name, presence: true
    validates :description, presence: true

    # find authorized users from this AuthorityGroup
    def usernames
      users = authorized_usernames
      return users.split(', ') unless users.nil?
      []
    end

    # find authorized users from the associated Hydramata::Group if one exists
    def reload_authorized_usernames
      loaded_users = reload_authority_group_users
      return usernames if loaded_users.empty?
      loaded_users
    end

    # if given a pid, the associated group must exist.
    def valid_group_pid?
      return true if associated_group_pid.blank?
      return true unless associated_group.nil?
      false
    end

    def associated_group
      begin
        return Hydramata::Group.find(associated_group_pid)
      rescue
        return nil
      end
    end

    def self.authority_group_for(auth_group_name:)
      begin
        auth_group = AuthorityGroup.find_by(auth_group_name: auth_group_name)
      rescue
        nil
      end
      auth_group
    end

    # override in each authority_group to set parameters if loading from yml
    #
    # @param usernames_file [string] - optional, 'relative/path/to/usernames_file.yml'
    # @param file_key [String] - optional, the key to search in file, i.e. 'super_admin_usernames'
    # @return [Array<String>] - ['a_username', 'another_username'] or []
    def self.initialize_usernames(usernames_file: nil, file_key: nil)
      load_usernames(usernames_file: usernames_file, file_key: file_key)
    end

    def initial_user_list
      return [] if controlling_class_name.blank?
      class_name = controlling_class_name
      class_name.constantize.initialize_usernames
    end

    def formatted_initial_list
      initial_user_list.map {|a| %Q(#{a}) }.join(", ")
    end

    def destroyable?
      return false if class_exists?
      true
    end

    def class_exists?
      return true if defined? controlling_class_name.constantize::AUTH_GROUP_NAME
      false
    end

    private

    # reload user list from associated Hydramata::Group if one exists
    def reload_authority_group_users
      return [] if associated_group.nil?
      members = []
      associated_group.members.each do |person|
        members << person.user.username
      end
      members
    end

    # included as a way to offer initial loading of authority_group from yml (structure as follows)
    # a_lookup_key:
    # - a_username
    # - another_username
    def self.load_usernames(usernames_file: nil, file_key: nil)
      return [] unless usernames_file

      file_to_load = Rails.root.join(usernames_file)
      if file_to_load.exist?
        interpreted_file_to_load = YAML.load(ERB.new(file_to_load.read).result)
        usernames = interpreted_file_to_load.fetch(Rails.env).fetch(file_key)
        return Array.wrap(usernames)
      else
        $stderr.puts "Unable to find usernames file: #{file_to_load}"
        return []
      end
    end
  end
end
