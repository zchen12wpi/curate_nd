require 'spec_helper'

describe CatholicDocument do
  subject {  FactoryGirl.build(:catholic_document) }

  it { should have_unique_field(:title) }

  it_behaves_like 'is_a_curation_concern_model'
  it_behaves_like 'with_access_rights'
  it_behaves_like 'can_be_a_member_of_library_collections'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'with_json_mapper'

  describe 'new catholic document' do
    let(:catholic_document) { FactoryGirl.build(:catholic_document) }

    it "should initialize dates and stamp preferred format on create" do
      catholic_document.valid?
      expect(catholic_document.date_modified).to eq(Date.today)
      expect(catholic_document.date_uploaded).to eq(Date.today)
      expect(catholic_document.preferred_file_format).to eq('')
    end
  end
end
