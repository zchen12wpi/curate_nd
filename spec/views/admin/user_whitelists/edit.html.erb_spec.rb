require 'spec_helper'

describe "admin/user_whitelists/edit" do
  before(:each) do
    @admin_user_whitelist = assign(:admin_user_whitelist, stub_model(Admin::UserWhitelist,
      :username => "MyString"
    ))
  end

  it "renders the edit admin_user_whitelist form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_user_whitelist_path(@admin_user_whitelist), "post" do
      assert_select "input#admin_user_whitelist_username[name=?]", "admin_user_whitelist[username]"
    end
  end
end
