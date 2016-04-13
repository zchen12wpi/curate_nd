# The access is controlled by the work_type_permission.yml file
# For a work, all the registered users will be given create access
# unless a group id is specified instead of 'all' in the yml file.
class WorkTypePolicy
  attr_accessor :user, :permission_rules

  def initialize( user: current_user, permission_rules: WORK_PERMISSIONS )
    self.user = user
    self.permission_rules = permission_rules
  end

  def authorized_for?( work_type )
    begin
      work_type_permission = permission_rules.fetch( work_type.to_s )
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

  private

  def user_groups
    @user_groups ||= user.groups
  end

  def user_has_privileged_group?( group_keys )
    privileged_groups = Array.wrap( group_keys )
    users_privileged_groups = user_groups & privileged_groups
    users_privileged_groups.any?
  end
end
