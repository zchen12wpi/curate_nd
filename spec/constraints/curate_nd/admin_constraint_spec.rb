require 'spec_helper'

describe CurateND::AdminConstraint do
  context '.is_admin?' do
    subject { CurateND::AdminConstraint.is_admin?(user) }

    context 'for object responding to username' do
      let(:user) { double(username: username) }

      context 'with username macthing data store' do
        let(:username) { ENV['USER'] }
        it { should be_truthy }
      end

      context 'with username not macthing data store' do
        let(:username) { "not-#{ENV['USER']}" }
        it { should be_falsey }
      end
    end

    context 'for object not responding to username' do
      let(:user) { username }

      context 'with to_s macthing data store' do
        let(:username) { ENV['USER'] }
        it { should be_truthy }
      end

      context 'with to_s not macthing data store' do
        let(:username) { "not-#{ENV['USER']}" }
        it { should be_falsey }
      end
    end

  end
end
