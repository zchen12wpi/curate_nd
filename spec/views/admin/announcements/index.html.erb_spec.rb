require 'spec_helper'

describe "admin/announcements/index" do
  before(:each) do
    assign(:admin_announcements, announcements)
  end
  let(:announcements) {
    Kaminari.paginate_array(
      [
        stub_model(Admin::Announcement,:message => "MyText"),
        stub_model(Admin::Announcement,:message => "MyText")
      ]
    ).page(1)
  }

  it "renders a list of admin/announcements" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
