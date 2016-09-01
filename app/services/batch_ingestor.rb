require 'json'
require 'net/http'
require 'time'
require 'uri'

class BatchIngestor

  attr_reader :content_data, :task_function_name, :job_id_prefix, :content_file_name, :job_id

  SERVER_URL = 'http://localhost:15000/jobs/'

  def initialize(job_id_prefix, task_function_name, content_file_name, content_data)
    @job_id_prefix = job_id_prefix
    @task_function_name = task_function_name
    @content_file_name = content_file_name
    @content_data = content_data
  end

  def self.start_reingest(content_data)
    job_id_prefix = 'reingest'
    task_function_name = 'start-reingest'
    content_file_name = 'fedora_pids'
    new(job_id_prefix, task_function_name, content_file_name, content_data).submit
  end

  def self.start_osf_archive_ingest(content_data)
    job_id_prefix = 'osfarchive'
    todo_function_name = 'start-osf-archive-ingest'
    content_file_name = 'osf_projects'
    content_data[:project_url] = get_osf_url(content_data[:project_identifier])
    new(job_id_prefix, task_function_name, content_file_name, content_data).submit_ingest
  end

  private

  def submit_ingest
    @job_id = make_job_id
    create_batch_job
    add_job_file
    add_job_file('JOB', task_list, true)
    submit_batch_job
  end

  def get_osf_url(project_identifier)
    'https://osf.io' + '/' + project_identifier + '/'
  end

  def make_job_id
    time_format = job_id_prefix + '%Y%b%e%H%M%s'
    return Time.now.strftime(time_format)
  end

  # create Contents of JOB file to start reingest in batch ingest system
  def task_list
    list = {}
    list['Todo'] = []
    list['Todo'].push(task_function_name)
    list
  end

  # does PUT /jobs/:jobid to create data dir on batch ingest side
  def create_batch_job
    url = SERVER_URL + job_id
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.path)
    http.request(request)
  end

  # does PUT /jobs/:jobid to create data dir on batch ingest side
  def add_job_file
    want_json = true
    url = SERVER_URL + job_id + '/files/' + content_file_name
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.path)
    request.body = if want_json == true
                     JSON.generate(content_data)
                   else
                     content_data.to_s
                   end
    http.request(request)
  end

  # does POST /jobs/:jobid/queue to start process on batch ingest side
  def submit_batch_job
    url = SERVER_URL + @job_id + '/queue'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.request_post(uri.path, 'submit') do |response|
      p response.code
    end
  end
end
