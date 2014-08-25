require 'spec_helper'

describe "admin/announcements/edit" do
  before(:each) do
    @admin_announcement = assign(:admin_announcement, FactoryGirl.build_stubbed(:admin_announcement))
  end

  it "renders the edit admin_announcement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_announcement_path(@admin_announcement), "post" do
      assert_select "textarea#admin_announcement_message[name=?]", "admin_announcement[message]"
    end
  end
end
