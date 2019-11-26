module Devise::MultiAuth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController

    def orcid
      # We do not allow Orcid as an authentication method; We do use Orcid's authentication
      # to ensure that the connection to an Orcid account is valid; The CurateND person enters
      # their ORCID, then authenticates to orcid.org. When that succeeds, we know that the person
      # is the owner of that ORCID.
    end

    def oktaoauth
      @user = User.from_omniauth(request.env["omniauth.auth"])
      omni = request.env["omniauth.auth"]
      if @user.persisted?
        set_flash_message(:notice, :success, kind: t("omniauth.provider_name.#{omni['provider']}", default: omni['provider'])) if is_navigational_format?
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to root_path
      end
    end

    private

    def authentication_from_external_app
      omni = request.env["omniauth.auth"]
      if @user = Authentication.find_user_by_provider_and_uid(omni['provider'], omni['uid'])
        set_flash_message(:notice, :success, kind: t("omniauth.provider_name.#{omni['provider']}", default: omni['provider'])) if is_navigational_format?
        Devise::MultiAuth.capture_successful_external_authentication(@user, omni)
        sign_in_and_redirect @user, event: :authentication
      else
        session["devise.auth_data"] = request.env["omniauth.auth"].except('extra')
        redirect_to new_user_registration_path
      end
    end

  end
end
