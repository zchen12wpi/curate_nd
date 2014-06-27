class WorkTypePermissions
  def initialize( current_user )
    @user = current_user
  end

  def is_permitted?( work_type )
    begin
      work_type_permission = WORK_PERMISSIONS.fetch( work_type.to_s )
      open_to = work_type_permission.fetch( 'open' ) { 'nobody' }
      case open_to
        when 'all' then true
        when 'nobody' then false
        else @user.groups.include?( open_to )
      end
    rescue KeyError
      false
    end
  end
end
