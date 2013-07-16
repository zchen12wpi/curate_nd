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
    begin
      subject.run
    rescue Exception => e
      file = GenericFile.find(generic_file.pid)
      $stderr.puts "*" * 80
      $stderr.puts "pid: #{generic_file.pid}"
      $stderr.puts "mime_type: #{file.mime_type.inspect}"
      $stderr.puts "format_label: #{file.format_label.inspect}"
      $stderr.puts "-" * 80
      $stderr.puts e
      $stderr.puts "-" * 80
      $stderr.puts e.backtrace.join("\n")
      $stderr.puts "*" * 80
      raise e
    end
  end
end
