require 'spec_helper'

describe CurationConcern::GenericFileActor do

  describe '#create' do
    user = FactoryGirl.create(:user)
    curation_concern = FactoryGirl.create_curation_concern(:generic_work, user)
    files = Array.new
    files << Rack::Test::UploadedFile.new(__FILE__, 'image', false)
    files << Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)
    generic_file = GenericFile.new
    generic_file.visibility ||= Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    file ||= Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)
    generic_file.file ||= file
    generic_file.label = file.original_filename
    generic_file.batch = curation_concern

    it "uploads multiple files" do
      actor = CurationConcern::GenericFileActor.new(generic_file, user, file: files)
      expect(actor.curation_concern).to eq generic_file
      expect(actor.user).to eq user
      expect(actor.attributes['file']).to eq files
      expect(actor.download_create_cloud_resources).to eq true
    end

  end

end
