class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include CurateController

  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :filter_notify

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

  after_filter :store_location

  def store_location
    return true unless request.get?
    return true if request.xhr?
    return true if request.path =~ /\A\/downloads\//
    return true if request.path =~ /\A\/users\//
    session[:previous_url] = request.fullpath
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  protected

  def exception_handler(exception)
    begin
      Harbinger.call(reporters: [exception, current_user, request], channels: [:database, :logger])
    rescue StandardError => e
      logger.error("Unable to notify Harbinger. #{e.class}: #{e}")
    end
    super(exception)
  end
end
