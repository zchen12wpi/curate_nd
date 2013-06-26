require 'spec_helper'

describe CharacterizeJob do
  let(:user) { FactoryGirl.create(:user) }
  let(:image_file) {
    Rack::Test::UploadedFile.new(
      File.expand_path('../../fixtures/files/image.png', __FILE__),
      'image/png',
      false
    )
  }
  let(:generic_file) { FactoryGirl.create_generic_file(:senior_thesis, user, image_file ) }

  subject { CharacterizeJob.new(generic_file.pid) }

  it 'should use create a thumbnail' do
    subject.run
  end
end
