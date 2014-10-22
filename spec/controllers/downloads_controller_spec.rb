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
        response.should be_success
        response.headers.keys.include?("X-Accel-Redirect").should be_falsey
        response.body.should == generic_file.content.content
      end
      it 'sends the file through proxy' do
        use_proxy_download
        get :show, id: generic_file.to_param
        response.should be_success
        response.headers['X-Accel-Redirect'].should == "/download-content/#{generic_file.noid}"
        response.body.blank?.should be_truthy
      end
    end
  end
end
