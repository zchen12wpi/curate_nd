require 'spec_helper'

describe Admin::UserWhitelist do
  context '.whitelisted?' do
    subject { described_class.whitelisted?(user) }

    context 'with a username' do
      context 'that is empty' do
        let(:user) { nil }
        it { should be_false }
      end

      context 'that is not whitelisted' do
        context 'and is not an admin' do
          let(:user) { 'i am not an admin' }
          it { should be_false }
        end

        context 'and is an admin username' do
          let(:user) { 'i_am_an_admin' }
          before(:each) { CurateND::AdminConstraint.should_receive(:is_admin?).with(user).and_return(true) }
          it { should be_true }
        end
      end
      context 'that is whitelisted' do
        before(:each) {
          Admin::UserWhitelist.create(username: user)
        }
        context 'and is an admin' do
          let(:user) { 'i am not an admin' }
          it { should be_true }
        end

        context 'and is an admin username' do
          let(:user) { 'i_am_an_admin' }
          before(:each) { CurateND::AdminConstraint.should_receive(:is_admin?).with(user).and_return(true) }
          it { should be_true }
        end
      end
    end
  end
end
