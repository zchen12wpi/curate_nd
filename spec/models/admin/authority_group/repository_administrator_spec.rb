require 'spec_helper'

describe Admin::AuthorityGroup::RepositoryAdministrator do
  it_behaves_like 'is_an_authority_group_class', described_class, :admin_grp

  context 'behavior' do
    let(:user) { double(username: username) }
    let(:username) { 'some_random_user' }
    let(:username2) { 'someone_else' }
    let!(:admin) { FactoryGirl.create(:admin_grp, authorized_usernames: username) }
    let!(:super_admin) { FactoryGirl.create(:super_admin_grp, authorized_usernames: username2) }

    it 'is an admin' do
      expect(CurateND::AdminConstraint.is_admin?(user)).to be_truthy
    end

    it 'includes usernames from both admin + super_admin ' do
      expect(described_class.new.usernames).to eq([username, username2])
    end
  end
end
