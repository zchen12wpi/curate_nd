class UserProfilesController < ApplicationController
  with_themed_layout 'user_profile_layout'

  def orcid_settings
    render 'orcid_settings'
  end
end
