require 'spec_helper'

describe "application/_announcements" do

  let(:current_user) { double }
  before(:each) do
    controller.stub(:current_user).and_return(current_user)
    Admin::Announcement.stub(:for).with(current_user).and_return(announcements)
  end

  context 'without announcements' do
    let(:announcements) { [] }

    it "renders an empty div" do
      render
      expect(rendered.strip).to be_empty
    end
  end

  context 'with announcements' do
    let(:announcements) { [FactoryGirl.build_stubbed(:admin_announcement)] }

    it "renders the announcments" do
      render
      expect(rendered).to have_tag('#announcements .announcement-listing .announcement') do
        with_tag(".announcement-dismiss", count: 1)
      end
    end
  end
end
