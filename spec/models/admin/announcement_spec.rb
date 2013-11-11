require 'spec_helper'

describe Admin::Announcement do
  let(:attributes) { {start_at: 2.days.ago, end_at: 2.days.from_now } }
  context 'test support' do
    subject { FactoryGirl.build(:admin_announcement, attributes) }
    it 'has a valid factory' do
      expect(subject).to be_valid
    end

    it 'creates and cascade destroys' do
      subject.save!
      expect {
        subject.dismissals.create(user_id: '123')
      }.to change(Admin::AnnouncementDismissal, :count).by(1)

      expect {
        expect {
          subject.destroy
        }.to change(Admin::Announcement, :count).by(-1)
      }.to change(Admin::AnnouncementDismissal, :count).by(-1)
    end
  end

  context '.dismiss' do
    let(:user) { FactoryGirl.create(:user) }
    let(:announcement) { FactoryGirl.create(:admin_announcement, attributes) }

    it 'should change if the user' do
      announcement
      expect {
        Admin::Announcement.dismiss(announcement.to_param, user)
      }.to change(Admin::Announcement.for(user), :count).by(-1)
    end
  end

  context '.for' do
    let!(:announcement) { FactoryGirl.create(:admin_announcement, attributes) }
    subject { Admin::Announcement.for(user) }

    context 'without user' do
      let(:user) { nil }
      it { should eq [announcement] }
    end

    context 'with a user that has not dismissed something' do
      let(:user) { double(to_param: '123') }
      it { should eq [announcement] }
    end

    context 'with a user that has dismissed the announcement' do
      let!(:another_announcement) { FactoryGirl.create(:admin_announcement, attributes) }
      let(:user) { double(to_param: '123') }
      before(:each) {
        Admin::Announcement.dismiss(announcement.to_param, user)
      }
      it { should eq [another_announcement] }
    end
  end
end
