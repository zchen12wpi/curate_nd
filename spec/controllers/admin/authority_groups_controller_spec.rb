require 'spec_helper'

describe Admin::AuthorityGroupsController, type: :controller do
  let(:super_admin_authority_group) { FactoryGirl.create(:super_admin_grp) }
  let(:user) { FactoryGirl.create(:user, username: 'an_admin_username') }
  let(:auth_group) { FactoryGirl.create(:auth_group, auth_group_name: 'a name', description: 'test desc') }

  before(:each) do
    super_admin_authority_group
    sign_in user
  end

  describe '#index' do
    it 'renders an index page to admin user' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template(:index)
    end
  end

  describe '#new' do
    it 'renders an new form to admin user' do
      get :new
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe '#show' do
    it 'renders an new form to admin user' do
      get :show, { id: super_admin_authority_group.to_param }
      expect(response).to be_successful
    end
  end

  describe '#create' do
    it "should create an authority group" do
      expect {
        post :create, admin_authority_group: { auth_group_name: 'a name', description: 'test desc' }
      }.to change{Admin::AuthorityGroup.count}.by(1)
      expect(response).to be_redirect
      expect(flash[:notice]).to eq 'Authority Group was successfully created.'
    end
  end

  describe '#edit' do
    it "should display the edit form" do
      get :edit, id: super_admin_authority_group.id
      expect(response).to be_successful
    end
  end

  describe '#update' do
    before do
      auth_group
    end

    it 'updates the authority group' do
      put :update, id: auth_group.id, admin_authority_group: { authorized_usernames: 'someone' }
      expect(response).to be_redirect
      expect(flash[:notice]).to eq 'Authority Group was successfully updated.'
    end
  end

  describe '#refresh' do
    before do
      auth_group
      allow(controller).to receive(:user_list_from_associated_group).and_return(['user1, user2, user3'])
    end

    it 'updates authorized users from associated hydramata group members' do
      get :refresh, id: auth_group.id
      expect(response).to be_redirect
      expect(flash[:notice]).to eq "User abilities refreshed for this Authority Group."
    end
  end

  describe '#destroy' do
    describe 'destroyable group' do
      before do
        auth_group
      end
      it 'delets the group' do
        delete :destroy, id: auth_group.id
        expect(response).to be_redirect
        expect(flash[:notice]).to eq "Authority Group '#{auth_group.auth_group_name}' has been deleted."
      end
    end

    describe 'non-destroyable group' do
      it 'does not delete' do
        delete :destroy, id: super_admin_authority_group.id
        expect(response).to be_redirect
        expect(flash[:notice]).to eq 'This Authority Group cannot be removed.'
      end
    end
  end

  describe '#reinitialize' do
    let(:admin_group) { FactoryGirl.create(:admin_grp, authorized_usernames: 'someone') }

    before do
      admin_group
    end

    it 'returns authorized users to initial list' do
      get :reinitialize, id: admin_group.id
      expect(response).to be_redirect
      expect(flash[:notice]).to eq 'User abilities refreshed for this Authority Group.'
    end
  end
end
