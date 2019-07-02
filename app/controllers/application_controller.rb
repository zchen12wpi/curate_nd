class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include CurateController

  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_filter :filter_notify
  # enable profiling for admin users
  before_action :enable_profiling

  def filter_notify
    # remove error inserted since we are not showing a page before going to web access, this error message always shows up a page too late.
    # for the moment just remove it always.  If we show a transition page in the future we may want to  display it then.
    if flash[:alert].present?
      flash[:alert] = [flash[:alert]].flatten.reject do |item|
        item == "You need to sign in or sign up before continuing."
      end
      flash[:alert] = nil if flash[:alert].blank?
    end
  end

  before_filter :store_location

  def store_location
    return true unless request.get?
    return true if request.xhr?
    return true if request.path =~ /\A\/downloads\//
    return true if request.path =~ /\A\/users\//
    return true if request.path =~ /\A\/terms_of_service_agreements\//
    session[:previous_url] = request.fullpath
  end

  def after_sign_in_path_for(resource)
    ensure_user_has_profile(resource) if resource.is_a?(User)
    session[:previous_url] || root_path
  end

  protected

  # Brought in to resolve a problem with OmniAuth and other authentications.
  # If we lean entirely on OmniAuth (by migrating Devise-CAS to Omniauth-CAS),
  # then this can go away.
  #
  # https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview#using-omniauth-without-other-authentications
  def new_session_path(scope)
    # Devise gets confused. The new_session_path that is being called does not
    # appear to be generated. This is a shim.
    send("new_#{scope}_session_path")
  end
  helper_method :new_session_path

  # Creates an associated Person and Profile if none exists after the User logs in.
  # This is a stop gap to handle https://jira.library.nd.edu/browse/DLTP-1354. We should
  # remove this once we remove Person and/or Profile objects.
  def ensure_user_has_profile(user)
    unless user.person && user.person.profile.present?
      account = Account.to_adapter.get!(user.id)
      update_status = account.update_with_password({ "name" => user.username })
    end
  end

  # Enables Preformance Profiling for Admin Users
  def enable_profiling
    if current_user && CurateND::AdminConstraint.is_admin?(current_user.username)
      Rack::MiniProfiler.authorize_request
    end
  end
end
