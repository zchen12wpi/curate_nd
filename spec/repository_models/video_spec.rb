require 'spec_helper'

describe Video do
  subject {  FactoryGirl.build(:video) }

  it { should have_unique_field(:title) }

  it_behaves_like 'is_a_curation_concern_model'
  it_behaves_like 'with_access_rights'
  it_behaves_like 'can_be_a_member_of_library_collections'
  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'with_json_mapper'

  describe 'new video' do
    let(:video) { FactoryGirl.build(:video) }

    it "should initialize dates and stamp preferred format on create" do
      video.valid?
      expect(video.date_modified).to eq(Date.today)
      expect(video.date_uploaded).to eq(Date.today)
      expect(video.preferred_file_format).to eq('')
    end
  end
end
