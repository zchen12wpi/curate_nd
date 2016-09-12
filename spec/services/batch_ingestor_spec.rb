require 'spec_helper'

RSpec::Matchers.define :a_put do |expected_path|
  match { |actual| actual.path == expected_path }
end

RSpec::Matchers.define :a_put_with do |expected_body|
  match { |actual| actual.body == expected_body }
end

RSpec.describe BatchIngestor do

  describe '#submit_ingest' do
    let(:subject) { described_class.new('job_id', 'task', 'file_name', ['abcde', 'defgh', 'ijklm']).submit_ingest }
    let(:response) { instance_double(Net::HTTPResponse, code: '200') }
    let(:http) { instance_double(Net::HTTP, request_post: response) }

    before(:each) do
      allow(Time).to receive(:now).and_return(Time.new('2011/01/01'))
    end

    it 'submits 4 correctly ordered requests' do
      allow(Net::HTTP).to receive(:new).and_return(http)
      expect(http).to receive(:request)
        .with(a_put('/jobs/job_id2011Jan0100001293858000'))
        .and_return(response)
        .ordered
      expect(http).to receive(:request)
        .with(a_put('/jobs/job_id2011Jan0100001293858000/files/file_name'))
        .and_return(response)
        .ordered
      expect(http).to receive(:request)
        .with(a_put('/jobs/job_id2011Jan0100001293858000/files/JOB'))
        .and_return(response)
        .ordered
      expect(http).to receive(:request_post)
        .with('/jobs/job_id2011Jan0100001293858000/queue','submit')
        .and_return(response)
        .ordered
      subject
    end

    it 'will report to Airbrake if response code not 200' do
      stub_request(:any, 'http://localhost:15000/jobs/job_id2011Jan0100001293858000')
        .to_return(status: 500)
      expect(Airbrake).to receive(:notify_or_ignore)
      expect { subject }.to raise_error("HTTP request failed with status 500")
    end

    it 'submits the content data' do
      allow(Net::HTTP).to receive(:new)
        .and_return(http)
      allow(http).to receive(:request)
        .and_return(response)
        .at_least(:once)
      expect(http).to receive(:request)
        .with(a_put_with('["abcde","defgh","ijklm"]'))
        .and_return(response)
        .once
      subject
    end

    it 'submits the task list' do
      allow(Net::HTTP).to receive(:new)
        .and_return(http)
      allow(http).to receive(:request)
        .and_return(response)
        .at_least(:once)
      expect(http).to receive(:request)
        .with(a_put_with('{"Todo":["task"]}'))
        .and_return(response)
        .once
      subject
    end
  end


  describe '#get_osf_url' do
    let(:subject) { described_class.get_osf_url('abcde') }
    it 'correctly generates a project_url' do
      expect(subject).to eq('https://osf.io/abcde/')
    end
  end

  it 'appends the content data with a project url' do
    mock_object = double(submit_ingest: true)
    expect(described_class).to receive(:new).with('osfarchive', 'start-osf-archive-ingest', 'osf_projects', { project_identifier: 'abcde', project_url: 'https://osf.io/abcde/' }).and_return(mock_object)
    described_class.start_osf_archive_ingest( project_identifier: 'abcde')
  end

end
