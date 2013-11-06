require 'spec_helper_features'

describe 'admin accounts behavior', FeatureSupport.options do
  context 'anonymous user' do
    it 'cannot start masquerading' do
      visit('/admin/accounts/start_masquerading')
      expect(page).to have_tag('h1', text: 'Page Not Found')
      expect(page.status_code).to eq(404)
    end

    it 'cannot see the /admin/accounts' do
      visit('/admin/accounts')
      expect(page).to have_tag('h1', text: 'Page Not Found')
      expect(page).to_not have_content('Accounts')
      expect(page.status_code).to eq(404)

    end
  end

  context 'non-admin user' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      login_as(user)
    end
    it 'cannot start masquerading' do
      visit('/admin/accounts/start_masquerading')
      expect(page).to have_tag('h1', text: 'Page Not Found')
      expect(page.status_code).to eq(404)
    end

    it 'cannot see the /admin/accounts' do
      visit('/admin/accounts')
      expect(page).to have_tag('h1', text: 'Page Not Found')
      expect(page).to_not have_content('Accounts')
      expect(page.status_code).to eq(404)
    end
  end

  context 'admin user' do
    let(:user) { FactoryGirl.create(:user, username: 'an_admin_username') }
    before(:each) do
      login_as(user)
    end
    it 'cannot see the /admin/accounts' do
      visit('/admin/accounts')
      expect(page).to_not have_tag('h1', text: 'Page Not Found')
      expect(page).to have_content('Accounts')
      expect(page.status_code).to eq(200)
    end

    it 'can start masquerading' do
      visit('/admin/accounts/start_masquerading')
      expect(page.status_code).to eq(200)
      expect(page).to have_content('begun masquerading')
    end

  end
end
