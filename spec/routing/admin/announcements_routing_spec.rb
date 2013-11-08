require "spec_helper"

describe Admin::AnnouncementsController do
  describe "routing" do
    context 'as admin' do
      before(:each) do
        CurateND::AdminConstraint.stub(:matches?).and_return(true)
      end
      it "routes to #dismiss" do
        delete("/dismiss_announcement/1").should route_to("admin/announcements#dismiss", id: '1')
      end

      it "routes to #index" do
        get("/admin/announcements").should route_to("admin/announcements#index")
      end

      it "routes to #new" do
        get("/admin/announcements/new").should route_to("admin/announcements#new")
      end

      it "routes to #show" do
        get("/admin/announcements/1").should route_to("admin/announcements#show", :id => "1")
      end

      it "routes to #edit" do
        get("/admin/announcements/1/edit").should route_to("admin/announcements#edit", :id => "1")
      end

      it "routes to #create" do
        post("/admin/announcements").should route_to("admin/announcements#create")
      end

      it "routes to #update" do
        put("/admin/announcements/1").should route_to("admin/announcements#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/admin/announcements/1").should route_to("admin/announcements#destroy", :id => "1")
      end

    end
  end

  describe "routing" do
    context 'as admin' do
      before(:each) do
        CurateND::AdminConstraint.stub(:matches?).and_return(false)
      end

      it "routes to #dismiss" do
        delete("/dismiss_announcement/1").should route_to("admin/announcements#dismiss", id: "1")
      end

      it "does not route to #index" do
        get("/admin/announcements").should_not route_to("admin/announcements#index")
      end

      it "does not route to #new" do
        get("/admin/announcements/new").should_not route_to("admin/announcements#new")
      end

      it "does not route to #show" do
        get("/admin/announcements/1").should_not route_to("admin/announcements#show", :id => "1")
      end

      it "does not route to #edit" do
        get("/admin/announcements/1/edit").should_not route_to("admin/announcements#edit", :id => "1")
      end

      it "does not route to #create" do
        post("/admin/announcements").should_not route_to("admin/announcements#create")
      end

      it "does not route to #update" do
        put("/admin/announcements/1").should_not route_to("admin/announcements#update", :id => "1")
      end

      it "does not route to #destroy" do
        delete("/admin/announcements/1").should_not route_to("admin/announcements#destroy", :id => "1")
      end

    end
  end
end
