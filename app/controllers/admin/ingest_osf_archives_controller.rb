class Admin::IngestOsfArchivesController < ApplicationController
  with_themed_layout('1_column')

  # GET /admin/ingest_osf_archives/new
  def new
    @archive = Admin::IngestOSFArchive.new
  end

  # POST /admin/ingest_osf_archives
  def create
    @archive = Admin::IngestOSFArchive.new(admin_ingest_osf_archive_params)

    if @archive.valid? && IngestOSFTools.create_osf_job(@archive)
      redirect_to admin_ingest_osf_archives_path, notice: 'Project ingest job was successfully created.'
    else
      render :new
    end
  end

  # GET /admin/ingest_osf_archives
  def index
    @archives = IngestOSFTools.get_osf_jobs
  end

  private

  def affiliations
    @affiliations ||= Affiliation.values.collect{|entity|[entity.label,entity.human_name]}
  end
  helper_method :affiliations

  def curation_concern
    GenericWork.new
  end
  helper_method :curation_concern

  def admin_ingest_osf_archive_params
    cleaned_params = params.require(:admin_ingest_osf_archive).permit(:project_identifier, :affiliation, :owner, administrative_unit: [])
    match = /^https?:\/\/[^\/]*\/([^\/]*).*$/.match cleaned_params[:project_identifier]
    cleaned_params[:project_identifier] = match[1] if match && match.length > 1
    cleaned_params
  end
end
