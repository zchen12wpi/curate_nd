class UsersController < ApplicationController
  respond_to(:html)
  layout 'curate_nd/1_column'

  def update
    update_user!
    redirect_to catalog_index_path, :notice =>"You updated your account successfully."
  end

  private

  def update_user!
    user.user_does_not_require_profile_update = true
    user.update_attributes(user_params)
    user.save!
  end

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require('user').permit(
      :name,
      :preferred_email,
      :alternate_email,
      :date_of_birth,
      :gender,
      :title,
      :campus_phone_number,
      :alternate_phone_number,
      :personal_webpage,
      :blog
    )
  end
end
