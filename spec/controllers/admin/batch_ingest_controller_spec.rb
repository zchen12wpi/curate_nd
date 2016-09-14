require 'spec_helper'

describe Admin::BatchIngestController, type: :controller do
  describe "#index" do
    let(:subject) { get :index }

    it "assigns @jobs using BatchIngestor#get_jobs" do
      allow_any_instance_of(BatchIngestor).to receive(:get_jobs).and_return("stuff from BatchIngestor.get_jobs")
      subject
      expect(assigns(:jobs)).to eq("stuff from BatchIngestor.get_jobs")
    end

    it "assigns @name_filter using name_filter param" do
      allow_any_instance_of(BatchIngestor).to receive(:get_jobs).and_return({})
      get :index, name_filter: "my name filter"
      expect(assigns(:name_filter)).to eq("my name filter")
    end

    it "assigns @status_filter using status_filter param" do
      allow_any_instance_of(BatchIngestor).to receive(:get_jobs).and_return({})
      get :index, status_filter: "my status filter"
      expect(assigns(:status_filter)).to eq("my status filter")
    end
  end
end
