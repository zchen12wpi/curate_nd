class Admin::IngestOsfArchivesController < ApplicationController
  with_themed_layout('1_column')

  # GET /admin/ingest_osf_archives/new
  def new
    @archive = Admin::IngestOSFArchive.new
  end

  # POST /admin/ingest_osf_archives
  def create
    @archive = Admin::IngestOSFArchive.build_with_id_or_url(admin_ingest_osf_archive_params)

    if @archive.valid? && IngestOSFTools.create_osf_job(@archive)
      redirect_to admin_batch_ingest_index_path(name_filter: 'osfarchive'), notice: 'Project ingest job was successfully created.'
    else
      render :new
    end
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
    params.require(:admin_ingest_osf_archive).permit(:project_identifier, :affiliation, :owner, administrative_unit: [])
  end
end
