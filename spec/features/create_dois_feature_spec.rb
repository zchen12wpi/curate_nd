require 'spec_helper_features'

VCR.configure do |c|
  c.ignore_request do |request|
    doi_uri = URI(Hydra::RemoteIdentifier.configuration.remote_services.fetch(:doi).url)
    URI(request.uri).host == doi_uri.host
  end
end

describe 'create DOIs feature', FeatureSupport.options do
  Curate.configuration.registered_curation_concern_types.each do |curation_concern_class_name|
    if  Hydra::RemoteIdentifier.registered?(:doi, curation_concern_class_name.constantize)
      # This is excluded as we don't yet create an OSF Archive via the Actor
      next if curation_concern_class_name.constantize == OsfArchive
      context "for #{curation_concern_class_name}" do
        CurationConcern::FactoryHelpers.load_factories_for(self, curation_concern_class_name.constantize)
        let(:curation_concern_class) { curation_concern_class_name.constantize }
        let(:curation_concern) { curation_concern_class.new(pid: CurationConcern::Utility.mint_a_pid ) }
        let(:user) { FactoryGirl.create(:user) }
        let(:attributes) {
          FactoryGirl.attributes_for(
            "public_#{curation_concern_class_name.underscore}",
            doi_assignment_strategy: :mint_doi,
            creator: ['A Special Creator'],
            publisher: ['University of Notre Dame']
          )
        }

        subject {
          CurationConcern::Utility.actor(curation_concern, user, attributes)
        }

        it 'should mint a remote identifier' do
          expect(curation_concern.identifier).to be_nil
          subject.create
          expect(curation_concern.reload.identifier).to_not be_nil
        end
      end
    end
  end
end
