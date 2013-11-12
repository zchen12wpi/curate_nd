require "spec_helper"

describe Admin::UserWhitelistsController do
  describe "routing" do
    context 'as admin' do
      before(:each) do
        CurateND::AdminConstraint.stub(:matches?).and_return(true)
      end

      it "routes to #index" do
        get("/admin/user_whitelists").should route_to("admin/user_whitelists#index")
      end

      it "routes to #new" do
        get("/admin/user_whitelists/new").should route_to("admin/user_whitelists#new")
      end

      it "routes to #show" do
        get("/admin/user_whitelists/1").should route_to("admin/user_whitelists#show", :id => "1")
      end

      it "routes to #edit" do
        get("/admin/user_whitelists/1/edit").should route_to("admin/user_whitelists#edit", :id => "1")
      end

      it "routes to #create" do
        post("/admin/user_whitelists").should route_to("admin/user_whitelists#create")
      end

      it "routes to #update" do
        put("/admin/user_whitelists/1").should route_to("admin/user_whitelists#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/admin/user_whitelists/1").should route_to("admin/user_whitelists#destroy", :id => "1")
      end

    end
  end

  describe "routing" do
    context 'as non-admin' do
      before(:each) do
        CurateND::AdminConstraint.stub(:matches?).and_return(false)
      end

      it "does not route to #index" do
        get("/admin/user_whitelists").should_not route_to("admin/user_whitelists#index")
      end

      it "does not route to #new" do
        get("/admin/user_whitelists/new").should_not route_to("admin/user_whitelists#new")
      end

      it "does not route to #show" do
        get("/admin/user_whitelists/1").should_not route_to("admin/user_whitelists#show", :id => "1")
      end

      it "does not route to #edit" do
        get("/admin/user_whitelists/1/edit").should_not route_to("admin/user_whitelists#edit", :id => "1")
      end

      it "does not route to #create" do
        post("/admin/user_whitelists").should_not route_to("admin/user_whitelists#create")
      end

      it "does not route to #update" do
        put("/admin/user_whitelists/1").should_not route_to("admin/user_whitelists#update", :id => "1")
      end

      it "does not route to #destroy" do
        delete("/admin/user_whitelists/1").should_not route_to("admin/user_whitelists#destroy", :id => "1")
      end

    end
  end
end
