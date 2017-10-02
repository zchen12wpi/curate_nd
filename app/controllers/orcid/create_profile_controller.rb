require 'net/http'
module Orcid
  class CreateProfileController < Orcid::ApplicationController
    respond_to :html
    before_filter :authenticate_user!

    def create
      if(params[:error] == "access_denied") then
        # if we get here, then orcid has redirected here when the user has denied access to the app
        flash[:error] = "You must authorize the application to read your ORCID profile."
        return redirect_to(orcid_settings_path)
      end

      unless Orcid.auth_user_with_code(params[:code], current_user) then
        flash[:error] = "Something went wrong when trying to retrieve your ORCID iD. Please try again later."
      end

      redirect_to(orcid_settings_path)
    end
  end
end
