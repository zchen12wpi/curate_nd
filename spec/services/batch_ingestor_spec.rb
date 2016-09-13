require 'spec_helper'

RSpec::Matchers.define :a_put do |expected_path|
  match { |actual| actual.path == expected_path }
end

RSpec::Matchers.define :a_put_with do |expected_body|
  match { |actual| actual.body == expected_body }
end

RSpec.describe BatchIngestor do

  describe '.default_job_id_builder' do
    it 'will leverage the current time' do
      as_of = Time.new(2008,6,21, 13,30,0, "+09:00").utc
      expect(described_class.default_job_id_builder('prefix', as_of)).to eq('prefix_2008Jun2104301214022600')
    end
  end

  describe '#submit_ingest' do
    let(:subject) do
      described_class.new('job_id', 'task', 'file_name', ['abcde', 'defgh', 'ijklm'], http: http, job_id_builder: job_id_builder).submit_ingest
    end
    let(:response) { instance_double(Net::HTTPResponse, code: '200') }
    let(:http) { instance_double(Net::HTTP, request_post: response) }
    let(:job_id_builder) { lambda { |job_id_prefix| "#{job_id_prefix}_mock_id" } }

    it 'submits 4 correctly ordered requests' do
      expect(http).to receive(:request)
        .with(a_put('/jobs/job_id_mock_id'))
        .and_return(response)
        .ordered
      expect(http).to receive(:request)
        .with(a_put('/jobs/job_id_mock_id/files/file_name'))
        .and_return(response)
        .ordered
      expect(http).to receive(:request)
        .with(a_put('/jobs/job_id_mock_id/files/JOB'))
        .and_return(response)
        .ordered
      expect(http).to receive(:request_post)
        .with('/jobs/job_id_mock_id/queue','submit')
        .and_return(response)
        .ordered
      subject
    end

    let(:unsuccessful_response) { instance_double(Net::HTTPResponse, code: 500) }
    it 'will report to Airbrake if response code not 200' do
      expect(http).to receive(:request).with(kind_of(Net::HTTP::Put)).and_return(unsuccessful_response)
      expect(Airbrake).to receive(:notify_or_ignore)
      expect { subject }.to raise_error("HTTP request failed with status 500")
    end

    it 'submits the content data' do
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
