class WorkTypePermissions
  attr_accessor :user

  def initialize( current_user )
    self.user = current_user
  end

  def is_permitted?( work_type )
    begin
      work_type_permission = WORK_PERMISSIONS.fetch( work_type.to_s )
      open_to = work_type_permission.fetch( 'open' ) { 'nobody' }
      case open_to
        when 'all' then true
        when 'nobody' then false
        else user_has_privileged_group?( open_to )
      end
    rescue KeyError
      false
    end
  end

  def user_groups
    @user_groups ||= user.groups
  end

  def user_has_privileged_group?( group_keys )
    privileged_groups = Array.wrap( group_keys )
    users_privileged_groups = user_groups & privileged_groups
    users_privileged_groups.any?
  end
end
