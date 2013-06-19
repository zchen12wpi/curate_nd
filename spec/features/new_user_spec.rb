require 'spec_helper'
require 'capybara/poltergeist'
require 'compass-rails'
require 'compass'
require 'bootstrap-datepicker-rails'
require 'timecop'

describe 'first time user', FeatureSupport.options do
  before(:each) do
    Warden.test_mode!
    @old_resque_inline_value = Resque.inline
    Resque.inline = true
  end
  after(:each) do
    Warden.test_reset!
    Resque.inline = @old_resque_inline_value
  end

  let(:user) {
    FactoryGirl.create(
      :user,
      agreed_to_terms_of_service: false,
      sign_in_count: 0
    )
  }

  xit 'prompts me to fill in my user profile the first time I log in' do
    visit('/')
    login_as(user)
    click_link "Get Started"
    click_button "I Agree"
    page.should have_content "Please Update Your Profile"
  end
end
