class Admin::IngestOsfArchivesController < ApplicationController
  with_themed_layout('1_column')

  # GET /admin/ingest_osf_archives/new
  def new
    @archive = Admin::IngestOSFArchive.new
  end

  # POST /admin/ingest_osf_archives
  def create
    @archive = Admin::IngestOSFArchive.new(admin_ingest_osf_archives_params)

    if IngestOSFTools.create_osf_job(@archive)
      redirect_to admin_ingest_osf_archives_path, notice: 'Archive ingest was successfully created.'
    else
      render action: 'new'
    end
  end

  # GET /admin/ingest_osf_archives
  def index
    @archives = IngestOSFTools.get_osf_jobs
  end

  private

  def admin_ingest_osf_archives_params
    params.require(:import_osf_archive).permit(:project_url, :project_identifier, :department, :owner)
  end
end
