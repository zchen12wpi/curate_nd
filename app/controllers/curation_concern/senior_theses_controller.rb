class CurationConcern::SeniorThesesController < CurationConcern::GenericWorksController
  helper AccordionBuilderHelper
  self.curation_concern_type = SeniorThesis

  def after_create_response
    flash[:curation_concern_pid] = curation_concern.pid
    super
  end

  def setup_form
    true
  end
end
