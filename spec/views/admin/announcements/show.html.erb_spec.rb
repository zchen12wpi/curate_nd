require 'spec_helper'

describe "admin/announcements/show" do
  before(:each) do
    @admin_announcement = assign(:admin_announcement, stub_model(Admin::Announcement,
      :message => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
