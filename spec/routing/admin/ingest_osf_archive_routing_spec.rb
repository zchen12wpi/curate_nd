require "spec_helper"

describe Admin::IngestOsfArchivesController do
  describe "routing" do
    context 'as admin' do
      before(:each) do
        allow(CurateND::AdminConstraint).to receive(:matches?).and_return(true)
      end

      it "routes to #new" do
        expect(get("/admin/ingest_osf_archives/new")).to route_to("admin/ingest_osf_archives#new")
      end

      it "routes to #create" do
        expect(post("/admin/ingest_osf_archives")).to route_to("admin/ingest_osf_archives#create")
      end
    end
  end

  describe "routing" do
    context 'as admin' do
      before(:each) do
        allow(CurateND::AdminConstraint).to receive(:matches?).and_return(false)
      end

      it "does not route to #index" do
        expect(get("/admin/ingest_osf_archives")).to_not route_to("admin/ingest_osf_archives#index")
      end

      it "does not route to #new" do
        expect(get("/admin/ingest_osf_archives/new")).to_not  route_to("admin/ingest_osf_archives#new")
      end

      it "does not route to #show" do
        expect(get("/admin/ingest_osf_archives/1")).to_not  route_to("admin/ingest_osf_archives#show", :id => "1")
      end

      it "does not route to #edit" do
        expect(get("/admin/ingest_osf_archives/1/edit")).to_not  route_to("admin/ingest_osf_archives#edit", :id => "1")
      end

      it "does not route to #create" do
        expect(post("/admin/ingest_osf_archives")).to_not  route_to("admin/ingest_osf_archives#create")
      end

      it "does not route to #update" do
        expect(put("/admin/ingest_osf_archives/1")).to_not  route_to("admin/ingest_osf_archives#update", :id => "1")
      end

      it "does not route to #destroy" do
        expect(delete("/admin/ingest_osf_archives/1")).to_not route_to("admin/ingest_osf_archives#destroy", :id => "1")
      end

    end
  end
end
