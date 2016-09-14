require "spec_helper"

describe Admin::IngestOsfArchivesController do
  describe "routing" do
    context 'as admin' do
      before(:each) do
        CurateND::AdminConstraint.stub(:matches?).and_return(true)
      end

      it "routes to #new" do
        get("/admin/ingest_osf_archives/new").should route_to("admin/ingest_osf_archives#new")
      end

      it "routes to #create" do
        post("/admin/ingest_osf_archives").should route_to("admin/ingest_osf_archives#create")
      end
    end
  end

  describe "routing" do
    context 'as admin' do
      before(:each) do
        CurateND::AdminConstraint.stub(:matches?).and_return(false)
      end

      it "does not route to #index" do
        get("/admin/ingest_osf_archives").should_not route_to("admin/ingest_osf_archives#index")
      end

      it "does not route to #new" do
        get("/admin/ingest_osf_archives/new").should_not route_to("admin/ingest_osf_archives#new")
      end

      it "does not route to #show" do
        get("/admin/ingest_osf_archives/1").should_not route_to("admin/ingest_osf_archives#show", :id => "1")
      end

      it "does not route to #edit" do
        get("/admin/ingest_osf_archives/1/edit").should_not route_to("admin/ingest_osf_archives#edit", :id => "1")
      end

      it "does not route to #create" do
        post("/admin/ingest_osf_archives").should_not route_to("admin/ingest_osf_archives#create")
      end

      it "does not route to #update" do
        put("/admin/ingest_osf_archives/1").should_not route_to("admin/ingest_osf_archives#update", :id => "1")
      end

      it "does not route to #destroy" do
        delete("/admin/ingest_osf_archives/1").should_not route_to("admin/ingest_osf_archives#destroy", :id => "1")
      end

    end
  end
end
