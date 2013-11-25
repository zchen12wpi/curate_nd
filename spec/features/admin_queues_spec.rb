require 'spec_helper_features'

describe 'admin queues behavior', FeatureSupport.options do
  describe 'anonymous user' do
    it 'cannot see the /admin/queues' do
      visit('/admin/queues')
      expect(page).to have_tag('h1', text: 'Page Not Found')
      expect(page).to_not have_content('Queue')
    end
  end

  describe 'non-admin user' do
    let(:user) { FactoryGirl.create(:user) }
    it 'cannot see the /admin/queues' do
      login_as(user)
      visit('/admin/queues')
      expect(page).to have_tag('h1', text: 'Page Not Found')
      expect(page).to_not have_content('Queue')
    end
  end

  describe 'admin user' do
    let(:user) { FactoryGirl.create(:user, username: 'an_admin_username') }
    xit 'can see the /admin/queues' do
      login_as(user)
      visit('/admin/queues')
      expect(page).to_not have_tag('h1', text: 'Page Not Found')
      expect(page).to have_content('Queue')
    end
  end
end
