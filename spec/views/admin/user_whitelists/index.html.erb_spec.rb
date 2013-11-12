require 'spec_helper'

describe "admin/user_whitelists/index" do
  before(:each) do
    assign(:admin_user_whitelists, admin_user_whitelists)
  end
  let(:admin_user_whitelists) {
    Kaminari.paginate_array(
      [
        stub_model(Admin::UserWhitelist,:username => "Username"),
        stub_model(Admin::UserWhitelist,:username => "Username")
      ]
    ).page(1)
  }

  it "renders a list of admin/user_whitelists" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Username".to_s, :count => 2
  end
end
