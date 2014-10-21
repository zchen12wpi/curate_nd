require 'spec_helper'

describe UserProfilesController do

  context 'GET orcid_settings' do
    it 'renders orcid_settings page' do
      get 'orcid_settings'
      expect(response).to render_template("orcid_settings")
    end
  end


end
