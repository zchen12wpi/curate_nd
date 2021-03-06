class UserProfilesController < ApplicationController
  with_themed_layout 'user_profile_layout'

  def orcid_settings
    render 'orcid_settings'
  end

  alias_method :after_successful_orcid_profile_request_path, :orcid_settings_path
end
