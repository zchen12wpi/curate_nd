require 'spec_helper'

RSpec.describe IngestOSFTools do
  let(:all_jobs) do
    [
      { job: "Job1", status: "success" },
      { job: "Job2", status: "error" },
      { job: "Job3", status: "queue" },
      { job: "Job4", status: "processing" },
      { job: "Job5", status: "ready" },
    ]
  end

  describe '#create_osf_job' do
    it 'creates the job using BatchIngestor'
  end
end
