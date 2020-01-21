class Admin::AuthorityGroupsController < ApplicationController
  include Hydra::AccessControlsEnforcement
  with_themed_layout '1_column'

  before_filter :verify_access
  before_action :set_authority_group, only: [:show, :edit, :update, :refresh, :reinitialize, :destroy]

  def index
    @admin_authority_groups = Admin::AuthorityGroup.all
  end

  def new
    @admin_authority_group = Admin::AuthorityGroup.new
  end

  def show
  end

  def create
   @admin_authority_group = Admin::AuthorityGroup.new(admin_authority_group_params)
   if valid_update? && @admin_authority_group.save
     @notice = 'Authority Group was successfully created.'
     redirect_to admin_authority_groups_path, notice: @notice
    else
      flash.now[:error] = (Array.wrap(@notice) << 'Administrative Group was not created.')
      render :new
    end
  end

  def edit
    @admin_authority_group.associated_group_pid = params[:associated_group_pid] unless params[:associated_group_pid].nil?
  end

  def update
    @admin_authority_group.assign_attributes(admin_authority_group_params)
    if valid_update? && @admin_authority_group.save
      @notice = 'Authority Group was successfully updated.'
      redirect_to admin_authority_group_path(@admin_authority_group), notice: @notice
    else
      flash.now[:error] = (Array.wrap(@notice) << 'Administrative Group was not updated.')
      render action: 'edit'
    end
  end

  def refresh
    @new_authorized_usernames = user_list_from_associated_group
    if !user_list_from_associated_group.empty? && authorized_users_changed?
      @admin_authority_group.authorized_usernames = @new_authorized_usernames
      if @admin_authority_group.save
        notice = 'User abilities refreshed for this Authority Group.'
      else
        notice = 'User abilities were not saved.'
      end
    else
      notice = 'User abilities are unchanged.'
    end
    redirect_to admin_authority_group_path(@admin_authority_group), notice: notice
  end

  def destroy
    if @admin_authority_group.destroyable?
      @admin_authority_group.destroy
      notice = "Authority Group '#{@admin_authority_group.auth_group_name}' has been deleted."
    else
      notice = 'This Authority Group cannot be removed.'
    end
    redirect_to admin_authority_groups_path, notice: notice
  end

  def reinitialize
    @new_authorized_usernames = @admin_authority_group.formatted_initial_list
    if authorized_users_changed?
      @admin_authority_group.authorized_usernames = @new_authorized_usernames
      if @admin_authority_group.save
        notice = 'User abilities refreshed for this Authority Group.'
      else
        notice = 'User abilities were not saved.'
      end
    else
      notice = 'User abilities are unchanged.'
    end
    redirect_to admin_authority_group_path(@admin_authority_group), notice: notice
  end

  private

  def verify_access
    render 'errors/401' unless current_user.can? :manage, Admin::AuthorityGroup
  end

  def set_authority_group
    @admin_authority_group = Admin::AuthorityGroup.find(params[:id])
  end

  def admin_authority_group_params
    params.require(:admin_authority_group).permit(:auth_group_name, :description, :controlling_class_name, :associated_group_pid, :authorized_usernames)
  end

  def valid_update?
    @notice = []
    valid_class = @admin_authority_group.class_exists?
    valid_group = @admin_authority_group.valid_group_pid?
    valid_name = valid_name_for?(@admin_authority_group)
    already_exists = already_exists?(@admin_authority_group.auth_group_name)

    # class name is a valid class in app
    @notice << "Please enter a valid group controlling class name." unless @admin_authority_group.controlling_class_name.blank? || valid_class
    # group pid is a group
    @notice << "Please enter a valid group pid." unless valid_group
    # cannot duplicate an authority_group_name
    @notice << 'An Authority Group with this name already exists' if @admin_authority_group.new_record? && already_exists
    # if class name given, group name must match name used by class
    @notice << "Authority Group Name for this controlling class must be '#{@admin_authority_group.controlling_class_name.constantize::AUTH_GROUP_NAME}'" if (valid_name == false && valid_class == true)
    # any errors means invalid authority group
    return false unless @notice.empty?
    true
  end

  def user_list_from_associated_group
    @admin_authority_group.reload_authorized_usernames.map {|a| %Q(#{a}) }.join(", ")
  end

  def authorized_users_changed?
    @admin_authority_group.authorized_usernames != @new_authorized_usernames
  end

  def already_exists?(group_name)
    return false if Admin::AuthorityGroup.authority_group_for(auth_group_name: group_name).nil?
    true
  end

  def valid_name_for?(authority_group)
    return true if authority_group.class_exists? == false
    authority_group.auth_group_name == authority_group.controlling_class_name.constantize::AUTH_GROUP_NAME
  end
end
