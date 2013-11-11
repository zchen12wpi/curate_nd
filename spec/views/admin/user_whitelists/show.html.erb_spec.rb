require 'spec_helper'

describe "admin/user_whitelists/show" do
  before(:each) do
    @admin_user_whitelist = assign(:admin_user_whitelist, stub_model(Admin::UserWhitelist,
      :username => "Username"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Username/)
  end
end
