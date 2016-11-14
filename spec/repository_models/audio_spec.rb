require 'spec_helper'

describe Audio do
  subject {  FactoryGirl.build(:audio) }

  it { should have_unique_field(:title) }

  it_behaves_like 'is_a_curation_concern_model'
  it_behaves_like 'with_access_rights'
  it_behaves_like 'can_be_a_member_of_library_collections'
  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'with_json_mapper'

  describe 'new audio' do
    let(:audio) { FactoryGirl.build(:audio) }

    it "should initialize dates and stamp preferred format on create" do
      audio.valid?
      expect(audio.date_modified).to eq(Date.today)
      expect(audio.date_uploaded).to eq(Date.today)
      expect(audio.preferred_file_format).to eq('')
    end
  end
end
