class CurationConcern::FindingAidsController < CurationConcern::GenericWorksController
  helper AccordionBuilderHelper
  self.curation_concern_type = FindingAid

  def after_create_response
    flash[:curation_concern_pid] = curation_concern.pid
    super
  end

end
