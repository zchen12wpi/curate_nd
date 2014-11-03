# Why accounts? Because Devise likes all things User related
class Admin::AccountsController < ApplicationController
  with_themed_layout('1_column')

  def index
    @users = User.search(params[:q]).page(params[:page])
  end

  def start_masquerading
    # This was a before_filter but when executed inline the action will always
    # fire...which means the current user could appear to masquerade as themself
    # when in fact they aren't masquerading at all
    masquerade_user!
    flash[:notice] = "You have begun masquerading as '#{current_user.username}'"
    flash[:alert] = "With great power comes great responsibility"
    redirect_to '/'
  end

  def disconnect_orcid_profile
    user = User.find(params[:id])
    Orcid.disconnect_user_and_orcid_profile(user)
    flash[:notice] = "Disconnected ORCID connection for '#{user.username}'."
    redirect_to(request.env["HTTP_REFERER"] || admin_accounts_path)
  end

end