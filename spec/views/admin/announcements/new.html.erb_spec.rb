require 'spec_helper'

describe "admin/announcements/new" do
  before(:each) do
    assign(:admin_announcement, stub_model(Admin::Announcement,
      :message => "MyText"
    ).as_new_record)
  end

  it "renders new admin_announcement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_announcements_path, "post" do
      assert_select "textarea#admin_announcement_message[name=?]", "admin_announcement[message]"
    end
  end
end
