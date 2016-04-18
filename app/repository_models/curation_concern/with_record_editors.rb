module CurationConcern
  module WithRecordEditors
    extend ActiveSupport::Concern

    included do
      before_destroy :clear_associations
    end

    def add_record_editor_group(group)
      raise ArgumentError, "parameter is #{group.inspect}, expected a kind of Hydramata::Group" unless group.is_a?(Hydramata::Group)
      record_editor_groups << group
      self.permissions_attributes = [{ name: group.pid, access: 'edit',
                                       type: 'group' }]
      self.save!
      group.works << self
      group.save!
    end

    # @param groups [Array<Hydramata::Group>] a list of groups to add
    def add_record_editor_groups(groups)
      groups.each do |g|
        add_record_editor_group(g)
      end
    end

    def remove_record_editor_group(group)
      return unless edit_groups.include?(group.pid)
      record_editor_groups.delete(group)
      self.edit_groups = edit_groups - [group.pid]
      self.save!
      group.works.delete(self)
      group.save!
    end

    # @param groups [Array<Hydramata::Group>] a list of users to remove
    def remove_record_editor_groups(groups)
      groups.each do |g|
        remove_record_editor_group(g)
      end
    end

    # @param user [User] the user account you want to grant edit access to.
    def add_record_editor(user)
      raise ArgumentError, "parameter is #{user.inspect}, expected a kind of User" unless user.is_a?(User)
      record_editors << user.person
      self.permissions_attributes = [{ name: user.user_key, access: 'edit', type: 'person' }] unless depositor == user.user_key
    end

    # @param users [Array<User>] a list of users to add
    def add_record_editors(users)
      users.each do |u|
        add_record_editor(u)
      end
    end

    # @param user [User] the user account you want to revoke edit access for.
    def remove_record_editor(user)
      remove_candidate_editor(user) if can_remove_record_editor?(user)
    end

    # @param users [Array<User>] a list of users to remove
    def remove_record_editors(users)
      users.each do |u|
        remove_record_editor(u)
      end
    end

    private

      # Decide if the user can be removed as an editor.  They cannot be removed
      # if they are the depositor or if they are not presently an editor
      # @param user [User] the user to remove
      def can_remove_record_editor?(user)
        depositor != user.user_key && record_editors.include?(user.person)
      end

      def clear_associations
        clear_record_editor_groups
        clear_record_editors
      end

      def clear_record_editor_groups
        record_editor_groups.each do |editor_group|
          remove_record_editor_group(editor_group)
        end
      end

      def clear_record_editors
        record_editors.each do |editor|
          remove_candidate_editor(User.find_by_repository_id(editor.pid))
        end
      end

      def remove_candidate_editor(user)
        record_editors.delete(user.person)
        self.edit_users = edit_users - [user.user_key]
        user.person.works.delete(self)
      end
  end
end
