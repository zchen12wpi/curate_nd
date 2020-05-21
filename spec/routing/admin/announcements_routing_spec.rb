require "spec_helper"

describe Admin::AnnouncementsController do
  describe "routing" do
    context 'as admin' do
      before(:each) do
        allow(CurateND::AdminConstraint).to receive(:matches?).and_return(true)
      end
      it "routes to #dismiss" do
        expect(delete("/dismiss_announcement/1")).to route_to("admin/announcements#dismiss", id: '1')
      end

      it "routes to #index" do
        expect(get("/admin/announcements")).to route_to("admin/announcements#index")
      end

      it "routes to #new" do
        expect(get("/admin/announcements/new")).to route_to("admin/announcements#new")
      end

      it "routes to #show" do
        expect(get("/admin/announcements/1")).to route_to("admin/announcements#show", :id => "1")
      end

      it "routes to #edit" do
        expect(get("/admin/announcements/1/edit")).to route_to("admin/announcements#edit", :id => "1")
      end

      it "routes to #create" do
        expect(post("/admin/announcements")).to route_to("admin/announcements#create")
      end

      it "routes to #update" do
        expect(put("/admin/announcements/1")).to route_to("admin/announcements#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(delete("/admin/announcements/1")).to route_to("admin/announcements#destroy", :id => "1")
      end

    end
  end

  describe "routing" do
    context 'as admin' do
      before(:each) do
        allow(CurateND::AdminConstraint).to receive(:matches?).and_return(false)
      end

      it "routes to #dismiss" do
        expect(delete("/dismiss_announcement/1")).to route_to("admin/announcements#dismiss", id: "1")
      end

      it "does not route to #index" do
        expect(get("/admin/announcements")).to_not route_to("admin/announcements#index")
      end

      it "does not route to #new" do
        expect(get("/admin/announcements/new")).to_not route_to("admin/announcements#new")
      end

      it "does not route to #show" do
        expect(get("/admin/announcements/1")).to_not route_to("admin/announcements#show", :id => "1")
      end

      it "does not route to #edit" do
        expect(get("/admin/announcements/1/edit")).to_not route_to("admin/announcements#edit", :id => "1")
      end

      it "does not route to #create" do
        expect(post("/admin/announcements")).to_not route_to("admin/announcements#create")
      end

      it "does not route to #update" do
        expect(put("/admin/announcements/1")).to_not route_to("admin/announcements#update", :id => "1")
      end

      it "does not route to #destroy" do
        expect(delete("/admin/announcements/1")).to_not route_to("admin/announcements#destroy", :id => "1")
      end

    end
  end
end
