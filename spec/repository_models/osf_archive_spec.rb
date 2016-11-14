require 'spec_helper'

describe OsfArchive do
  subject { OsfArchive.new }

  it { should have_unique_field(:title) }
  it { should have_unique_field(:source) }
  it { should have_unique_field(:type) }

  it_behaves_like 'is_a_curation_concern_model'
  it_behaves_like 'with_access_rights'
  it_behaves_like 'can_be_a_member_of_library_collections'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'with_json_mapper'

  describe 'new archive' do
    let(:archive) {OsfArchive.new}

    it "should set initialize dates and stamp type on create" do
      archive.valid?
      expect(archive.date_modified).to eq(Date.today)
      expect(archive.date_archived).to eq(Date.today)
      expect(archive.type).to eq('OSF Archive')
    end
  end
end
