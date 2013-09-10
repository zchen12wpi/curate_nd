require Curate::Engine.root.join('app/services/curation_concern')
class CurationConcern::SeniorThesesController < CurationConcern::GenericWorksController
  self.curation_concern_type = SeniorThesis
  respond_to(:html)
  layout 'curate_nd/1_column'

  rescue_from Citation::InvalidCurationConcern do |exception|
    redirect_to polymorphic_path([:curation_concern, curation_concern], :action => "edit"), notice: "Could not show citation. #{exception.message}"
  end

  def after_create_response
    flash[:curation_concern_pid] = curation_concern.pid
    redirect_to dashboard_index_path
  end

  def destroy
    title = curation_concern.to_s
    curation_concern.destroy
    flash[:notice] = "Deleted #{title}"
    respond_with { |wants|
      wants.html { redirect_to dashboard_index_path }
    }
  end

end
