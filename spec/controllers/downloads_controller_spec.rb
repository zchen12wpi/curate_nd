require 'spec_helper'

describe DownloadsController do

  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    let(:image_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/image.png'), 'image/png', false) }
    let(:generic_file) {
      FactoryGirl.create_generic_file(:generic_work, user, image_file) {|g|
        g.visibility = visibility
      }
    }

    let(:use_proxy_download) {
      Rails.application.config.use_proxy_for_download.enable
    }

    let(:no_proxy_download) {
      Rails.application.config.use_proxy_for_download.disable
    }
    describe '#send_content' do
      before do
        generic_file
      end
      it 'sends the file without proxy' do
        no_proxy_download
        get :show, id: generic_file.to_param
        expect(response).to be_success
        expect(response.headers.keys.include?("X-Accel-Redirect")).to be_falsey
        expect(response.body).to eq(generic_file.content.content)
      end
      it 'sends the file through proxy' do
        use_proxy_download
        get :show, id: generic_file.to_param
        expect(response).to be_success
        expect(response.headers['X-Accel-Redirect']).to eq("/download-content/#{generic_file.noid}")
        expect(response.body.blank?).to be_truthy
      end
    end
  end
end
