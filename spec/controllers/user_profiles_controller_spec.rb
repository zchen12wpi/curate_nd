require 'spec_helper'

describe UserProfilesController do

  it 'should have #after_successful_orcid_profile_request_path' do
    expect(controller.after_successful_orcid_profile_request_path).to eq(controller.orcid_settings_path)
  end

  context 'GET orcid_settings' do
    it 'renders orcid_settings page' do
      get 'orcid_settings'
      expect(response).to render_template("orcid_settings")
    end
  end


end
