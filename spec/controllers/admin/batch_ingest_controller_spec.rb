require 'spec_helper'

describe Admin::BatchIngestController, type: :controller do
  describe "#index" do
    let(:subject) { get :index }

    it "assigns @jobs using BatchIngestTools#get_jobs" do
      allow(BatchIngestTools).to receive(:get_jobs).and_return("stuff from BatchIngestTools.get_jobs")
      subject
      expect(assigns(:jobs)).to eq("stuff from BatchIngestTools.get_jobs")
    end
  end
end
