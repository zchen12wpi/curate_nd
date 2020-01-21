require 'spec_helper'

describe Admin::AuthorityGroup::ViewOnly do
  it_behaves_like 'is_an_authority_group_class', described_class, :view_only_grp

  context 'behavior' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let!(:authority_group) { FactoryGirl.create(:view_only_grp, authorized_usernames: user1.username) }

    it 'grants authority to view all works' do
      expect(user1.can?(:read, :all)).to be_truthy
    end

    it 'restricts authority to view all works' do
      expect(user2.can?(:read, :all)).to be_falsey
    end
  end
end
