require File.expand_path('../../helpers/common_objects_helper', __FILE__)
class CommonObjectsController < ApplicationController
  append_view_path(Rails.root.join('app/views/curation_concern/base'))
  include Hydra::Controller::ControllerBehavior
  layout 'common_objects'

  respond_to(:html, :jsonld)
  include Sufia::Noid # for normalize_identifier method
  prepend_before_filter :normalize_identifier
  def curation_concern
    @curation_concern ||= ActiveFedora::Base.find(params[:id], cast: true)
  end
  before_filter :curation_concern
  helper_method :curation_concern
  helper CommonObjectsHelper

  def unauthorized_path
    'app/views/curation_concern/base/unauthorized'
  end

  before_filter :enforce_show_permissions, only: [:show]
  rescue_from Hydra::AccessDenied do |exception|
    respond_with curation_concern do |format|
      format.html { render unauthorized_path, status: 401 }
      format.jsonld { render json: { error: 'Unauthorized' }, status: 401 }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.jsonld { render json: curation_concern.as_jsonld }
    end
  end

  def show_stub_information
    respond_to do |format|
      format.html
      format.jsonld { render json: curation_concern.as_jsonld.slice('@contect', '@id', 'nd:afmodel') }
    end
  end
end
