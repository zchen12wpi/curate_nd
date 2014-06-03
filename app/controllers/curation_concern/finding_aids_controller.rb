require Curate::Engine.root.join('app/services/curation_concern')
class CurationConcern::FindingAidsController < CurationConcern::GenericWorksController
  self.curation_concern_type = FindingAid

  def after_create_response
    flash[:curation_concern_pid] = curation_concern.pid
    super
  end

  def setup_form
    true
  end
end
