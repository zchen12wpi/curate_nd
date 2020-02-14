require 'spec_helper'

describe Dissertation do
  subject {  FactoryGirl.build(:dissertation) }

  it { should have_unique_field(:title) }

  it_behaves_like 'is_a_curation_concern_model'
  it_behaves_like 'with_access_rights'
  it_behaves_like 'can_be_a_member_of_library_collections'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'with_json_mapper'

  describe 'new dissertation' do
    let(:dissertation) { FactoryGirl.build(:dissertation) }

    it "should initialize dates and stamp preferred format on create" do
      dissertation.valid?
      expect(dissertation.date_modified).to eq(Date.today)
      expect(dissertation.date_uploaded).to eq(Date.today)
      expect(dissertation.preferred_file_format).to eq('')
    end
  end
end
