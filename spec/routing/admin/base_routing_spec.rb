require "spec_helper"

describe Admin::BaseController do
  describe "routing" do
    context 'as admin' do
      before(:each) do
        allow(CurateND::AdminConstraint).to receive(:matches?).and_return(true)
      end

      it "routes to #index" do
        expect(get("/admin")).to route_to("admin/base#index")
      end

    end
  end

  describe "routing" do
    context 'as non-admin' do
      before(:each) do
        allow(CurateND::AdminConstraint).to receive(:matches?).and_return(false)
      end

      it "does not route to #index" do
        expect(get("/admin")).to_not route_to("admin/base#index")
      end

    end
  end
end
