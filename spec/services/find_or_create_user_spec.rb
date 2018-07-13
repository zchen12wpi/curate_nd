require 'spec_helper'

RSpec.describe FindOrCreateUser do
  context 'when the user exists' do
    let!(:user) { FactoryGirl.create(:user, username: 'existing_user') }
    let(:subject) { FindOrCreateUser.call('existing_user') }

    it 'does not create a new user' do
      expect(User).not_to receive(:new)
      subject
    end

    it 'returns the existing user' do
      expect(subject).to eq(user)
    end

    context 'and it already has an associated person' do
      let!(:user) { FactoryGirl.create(:user_with_person, username: 'existing_user') }

      it 'does not create a new person' do
        expect(Person).not_to receive(:new)
        FindOrCreateUser.call('existing_user')
      end

      it 'does not create a new profile' do
        expect(Profile).not_to receive(:new)
        FindOrCreateUser.call('existing_user')
      end
    end

    context 'but it does not have an associated person' do
      let!(:user) { FactoryGirl.create(:user, username: 'existing_user') }

      it 'creates a new person if no person is given' do
        # I have no idea atm why this is getting called twice, but it is
        expect(Person).to receive(:new).at_least(:once).and_call_original
        FindOrCreateUser.call('existing_user')
      end
    end
  end

  context 'when the user does not exist' do
    context 'and a Person object is not provided' do
      let(:subject) { FindOrCreateUser.call('new_user') }

      it 'creates a new user' do
        expect(User.all.limit(2)).to eq([])
        subject
        expect(User.all.limit(2).map(&:name)).to eq(['new_user'])
      end

      it 'creates a new person' do
        expect(Person.all).to eq([])
        subject
        expect(Person.all.map(&:name)).to eq(['new_user'])
      end

      it 'creates a new profile' do
        expect(Profile.all).to eq([])
        user = subject
        expect(Profile.all.map(&:title)).to eq(['new_user'])
      end
    end
  end
end
