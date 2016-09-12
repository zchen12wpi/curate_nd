require 'json'
require 'net/http'
require 'time'

class BatchIngestor

  attr_reader :content_data, :task_function_name, :job_id_prefix, :content_file_name, :job_id, :http

  SERVER_URL = 'http://localhost:15000/'.freeze

  def initialize(job_id_prefix, task_function_name, content_file_name, content_data)
    @job_id_prefix = job_id_prefix
    @task_function_name = task_function_name
    @content_file_name = content_file_name
    @content_data = content_data
    uri = URI.parse(SERVER_URL)
    @http = Net::HTTP.new(uri.host, uri.port)
  end

  def self.start_reingest(content_data)
    job_id_prefix = 'reingest'
    task_function_name = 'start-reingest'
    content_file_name = 'fedora_pids'
    new(job_id_prefix, task_function_name, content_file_name, content_data).submit_ingest
  end

  def self.start_osf_archive_ingest(content_data)
    job_id_prefix = 'osfarchive'
    task_function_name = 'start-osf-archive-ingest'
    content_file_name = 'osf_projects'
    content_data[:project_url] = get_osf_url(content_data.fetch(:project_identifier))
    new(job_id_prefix, task_function_name, content_file_name, content_data).submit_ingest
  end

  def submit_ingest
    @job_id = make_job_id
    create_batch_job
    add_job_file(content_file_name, content_data)
    add_job_file('JOB', task_list)
    submit_batch_job
  end

  def self.get_osf_url(project_identifier)
    'https://osf.io' + '/' + project_identifier + '/'
  end

  private

  def make_job_id
    time_format = job_id_prefix + '%Y%b%d%H%M%s'
    return Time.now.strftime(time_format)
  end

  # create Contents of JOB file to start reingest in batch ingest system
  def task_list
    { 'Todo' => [task_function_name] }
  end

  # does PUT /jobs/:jobid to create data dir on batch ingest side
  def create_batch_job
    request = Net::HTTP::Put.new("/jobs/#{job_id}")
    response = http.request(request)
    handle_response('create_batch_job', response)
  end

  # does PUT /jobs/:jobid to create data dir on batch ingest side
  def add_job_file(name, data)
    request = Net::HTTP::Put.new("/jobs/#{job_id}/files/#{name}")
    request.body = JSON.generate(data)
    response = http.request(request)
    handle_response('add_job_file', response)
  end

  # does POST /jobs/:jobid/queue to start process on batch ingest side
  def submit_batch_job
    response = http.request_post("/jobs/#{job_id}/queue", "submit")
    handle_response('submit_batch_job', response)
  end

  def handle_response(method_name, response)
    return true if response.code == '200'
    report_to_airbrake(method_name, response.code)
  end

  class SubmitError < RuntimeError
  end

  def report_to_airbrake(method_name, code)
    exception = SubmitError.new("HTTP request failed with status " + code)
    Airbrake.notify_or_ignore(error_class: exception.class, error_message: exception, parameters: { task_name: task_function_name, method_name: method_name ,job_input: content_data })
    raise exception
  end
end
