require 'spec_helper'

describe Admin::FixityController, type: :controller do
  describe "#index" do
    let(:subject) { get :index }
    let(:bendo_success) { instance_double(Bendo::Services::FixityChecks::Response, { status: 200, body: 'body' }) }
    let(:bendo_error) { instance_double(Bendo::Services::FixityChecks::Response, { status: 400, body: 'body' }) }

    before(:each) do
      allow(Bendo::Services::FixityChecks).to receive(:call)
    end

    it "removes any empty string parameters before calling bendo" do
      expect(Bendo::Services::FixityChecks).to receive(:call).with(params: { "item" => "thing" })
      get :index, { item: "thing", status: "" }
    end

    it "removes any nil parameters before calling bendo" do
      expect(Bendo::Services::FixityChecks).to receive(:call).with(params: { "item" => "thing" })
      get :index, { item: "thing", scheduled_time_start: nil }
    end

    context 'when requesting html' do
      let(:subject) { get :index }

      context 'and bendo returns success' do
        before(:each) do
          allow(Bendo::Services::FixityChecks).to receive(:call).and_return(bendo_success)
        end

        it "assigns fixity_results" do
          subject
          expect(assigns(:fixity_results)).to eq('body')
        end

        it "does not flash an error" do
          subject
          expect(flash[:error]).not_to be_present
        end

        it "renders the index view" do
          expect(subject).to render_template(:index)
        end
      end

      context 'and bendo returns error' do
        before(:each) do
          allow(Bendo::Services::FixityChecks).to receive(:call).and_return(bendo_error)
        end

        it "assigns fixity_results as an empty array" do
          subject
          expect(assigns(:fixity_results)).to eq([])
        end

        it "flashes an error" do
          subject
          expect(flash[:error]).to be_present
        end

        it "renders the index view" do
          expect(subject).to render_template(:index)
        end
      end
    end

    context 'when requesting json' do
      let(:subject) { get :index, format: :json }

      context 'and bendo returns success' do
        before(:each) do
          allow(Bendo::Services::FixityChecks).to receive(:call).and_return(bendo_success)
        end

        it "renders the json data from bendo" do
          subject
          expect(response.body).to eq('body')
        end

        it "returns 200" do
          subject
          expect(response.status).to eq(200)
        end

        it "renders the fixity_results as json" do
          subject
          expect(response.content_type).to eq "application/json"
        end
      end

      context 'and bendo returns error' do
        before(:each) do
          allow(Bendo::Services::FixityChecks).to receive(:call).and_return(bendo_error)
        end

        it "renders an empty array" do
          subject
          expect(response.body).to eq("[]")
        end

        it "returns status given by bendo" do
          subject
          expect(response.status).to eq(bendo_error.status)
        end

        it "renders the fixity_results as json" do
          subject
          expect(response.content_type).to eq "application/json"
        end
      end
    end
  end
end
