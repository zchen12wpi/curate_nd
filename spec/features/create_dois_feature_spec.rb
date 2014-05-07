require 'spec_helper_features'


VCR.configure do |c|
  c.ignore_request do |request|
    doi_uri = URI(Hydra::RemoteIdentifier.configuration.remote_services.fetch(:doi).url)
    URI(request.uri).host == doi_uri.host
  end
end

describe 'create DOIs feature', FeatureSupport.options do
  Curate.configuration.registered_curation_concern_types.each do |curation_concern_class_name|
    CurationConcern::FactoryHelpers.load_factories_for(self, Dataset)
    let(:curation_concern_class) { curation_concern_class_name.constantize }
    let(:curation_concern) { curation_concern_class.new(pid: CurationConcern.mint_a_pid ) }
    let(:user) { FactoryGirl.create(:user) }
    let(:attributes) {
      FactoryGirl.attributes_for(
        :public_dataset,
        doi_assignment_strategy: :mint_doi,
        contributor: ['Donald Duck'],
        publisher: ['University of Notre Dame']
      )
    }

    subject {
      CurationConcern.actor(curation_concern, user, attributes)
    }

    it 'should mint a remote identifier' do
      expect {
        subject.create
      }.to change { curation_concern.identifier }.from(nil)
    end
  end
end
