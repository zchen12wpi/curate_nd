class OaiProvider < OAI::Provider::Base
  repository_name "OaiProvider" # gem throws an error without this value.
  repository_url 'http://localhost/provider'
  record_prefix "oai"
  admin_email ""
  sample_id "1"
  register_format(CurationConcernProvider::CurateFormat.instance)

  def initialize(controller:)
    super({ provider_context: :instance_based })
    self.model= CurationConcernProvider.new(controller: controller)
  end
end
