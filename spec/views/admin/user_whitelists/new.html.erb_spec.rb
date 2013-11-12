require 'spec_helper'

describe "admin/user_whitelists/new" do
  before(:each) do
    assign(:admin_user_whitelist, stub_model(Admin::UserWhitelist,
      :username => "MyString"
    ).as_new_record)
  end

  it "renders new admin_user_whitelist form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_user_whitelists_path, "post" do
      assert_select "input#admin_user_whitelist_username[name=?]", "admin_user_whitelist[username]"
    end
  end
end
