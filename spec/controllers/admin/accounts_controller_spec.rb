require 'spec_helper'

describe Admin::AccountsController do
  let(:user1) { FactoryGirl.build_stubbed(:user)}
  let(:user2) { FactoryGirl.build_stubbed(:user)}
  let(:search_results) { double(page: expected_array)}
  let(:expected_array) { [user1, user2]}
  context '#index' do
    before(:each) do
      User.should_receive(:search).with('user').and_return(search_results)
    end
    it 'should get a paginated list of users' do
      get :index, q: 'user'
      expect(response.status).to eq(200)
      expect(assigns(:users)).to eq(expected_array)
    end
  end

end