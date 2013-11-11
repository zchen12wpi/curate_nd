require "spec_helper"

describe Admin::BaseController do
  describe "routing" do
    context 'as admin' do
      before(:each) do
        CurateND::AdminConstraint.stub(:matches?).and_return(true)
      end

      it "routes to #index" do
        get("/admin").should route_to("admin/base#index")
      end

    end
  end

  describe "routing" do
    context 'as non-admin' do
      before(:each) do
        CurateND::AdminConstraint.stub(:matches?).and_return(false)
      end

      it "does not route to #index" do
        get("/admin").should_not route_to("admin/base#index")
      end

    end
  end
end
