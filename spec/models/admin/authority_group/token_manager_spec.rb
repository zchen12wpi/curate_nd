require 'spec_helper'

describe Admin::AuthorityGroup::TokenManager do
  it_behaves_like 'is_an_authority_group_class', described_class, :token_managers

  context 'behavior' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let!(:authority_group) { FactoryGirl.create(:token_managers, authorized_usernames: user1.username) }

    it 'grants authority to manage tokens' do
      expect(user1.can?(:manage, TemporaryAccessToken)).to be_truthy
    end

    it 'restricts authority to manage tokens' do
      expect(user2.can?(:manage, TemporaryAccessToken)).to be_falsey
    end
  end
end
