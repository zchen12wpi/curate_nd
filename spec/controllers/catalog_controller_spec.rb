require 'spec_helper'

describe CatalogController do

  describe "index action" do
    def assigns_response
      @controller.instance_variable_get("@response")
    end
    let(:user) { FactoryGirl.create(:user) }
    let!(:work1) { FactoryGirl.create(:generic_work, user: user, title:"Work1", subject:"my subject", administrative_unit: "Notre Dame:College of Arts and Letters:Africana Studies" ) }
    let!(:work2) { FactoryGirl.create(:generic_work, user: user, title:"Work2", subject:"my subject", administrative_unit: "Notre Dame:College of Arts and Letters:Africana Studies" ) }

    describe "with format :json" do
      before do
        sign_in user
        xhr :get, :index, format: :json
        response.should be_success
      end
      it "should return json" do
        json = JSON.parse(response.body)
        work_json = json["docs"].first
        work_json.should == {"pid"=>work1.pid, "title"=> "#{work1.title} (#{work1.human_readable_type})"}
      end
    end
  end

  describe "hierarchy_facet" do
    def assigns_response
      @controller.instance_variable_get("@response")
    end
    let(:user) { FactoryGirl.create(:user) }
    let!(:work1) { FactoryGirl.create(:generic_work, user: user, title:"Work1", subject:"my subject", administrative_unit: "Notre Dame:College of Arts and Letters:Africana Studies" ) }
    let!(:work2) { FactoryGirl.create(:generic_work, user: user, title:"Work2", subject:"my subject", administrative_unit: "Notre Dame:College of Arts and Letters:Africana Studies" ) }

    before do
      sign_in user
      xhr :get, :hierarchy_facet, id: 'admin_unit_hierarchy_sim', format: 'js'
      response.should be_success
    end

    describe "get hierarchy facet for administrative unit" do
      it "should be render hierarchy facet" do
        facet = assigns_response.facet_by_field_name('admin_unit_hierarchy_sim')
        facet.items.size.should >= 1
      end
    end
  end
end
