require 'spec_helper_features'

describe 'create DOIs feature', FeatureSupport.options do
  Curate.configuration.registered_curation_concern_types.each do |curation_concern_class_name|
    if curation_concern_class_name.constantize.ancestors.include?(CurationConcern::RemotelyIdentifiedByDoi::Attributes)
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
            doi_assignment_strategy: CurationConcern::RemotelyIdentifiedByDoi::GET_ONE,
            creator: ['A Special Creator'],
            publisher: ['University of Notre Dame']
          )
        }

        subject {
          CurationConcern::Utility.actor(curation_concern, user, attributes)
        }

        it 'should mint a remote identifier' do
          expect(Doi::Datacite).to receive(:mint).with(curation_concern)
          subject.create
        end
      end
    end
  end
end
