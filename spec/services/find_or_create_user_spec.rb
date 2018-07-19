require 'spec_helper'

RSpec.describe FindOrCreateUser do
  context 'when the user exists' do
    let!(:user) { FactoryGirl.create(:user, username: 'existing_user', name: 'Existing User') }
    let(:subject) { FindOrCreateUser.call('existing_user', 'Existing User') }

    it 'does not create a new user' do
      expect(User).not_to receive(:new)
      subject
    end

    it 'returns the existing user' do
      expect(subject).to eq(user)
    end

    it 'does not change the name' do
      subject = FindOrCreateUser.call('existing_user', 'New Name')
      expect(subject.name).to eq('Existing User')
    end

    context 'and it already has an associated person' do
      let!(:user) { FactoryGirl.create(:user_with_person, username: 'existing_user', name: 'Existing User') }

      it 'does not create a new person' do
        expect(Person).not_to receive(:new)
        FindOrCreateUser.call('existing_user', 'Existing User')
      end

      it 'does not change the person name' do
        subject = FindOrCreateUser.call('existing_user', 'New Name')
        expect(subject.person.name).to eq('Existing User')
      end

      it 'does not create a new profile' do
        expect(Profile).not_to receive(:new)
        FindOrCreateUser.call('existing_user', 'Existing User')
      end

      it 'does not change the profile title' do
        subject = FindOrCreateUser.call('existing_user', 'New Name')
        expect(subject.person.profile.title).to eq('Existing User')
      end
    end

    context 'but it does not have an associated person' do
      let!(:user) { FactoryGirl.create(:user, username: 'existing_user', name: 'Existing User') }

      it 'creates a new person if no person is given' do
        # I have no idea atm why this is getting called twice, but it is
        expect(Person).to receive(:new).at_least(:once).and_call_original
        FindOrCreateUser.call('existing_user', 'Existing User')
      end
    end
  end

  context 'when the user does not exist' do
    let(:subject) { FindOrCreateUser.call('new_user', 'New User') }

    it 'creates a new user with the given username and name' do
      expect(User.all.limit(2)).to eq([])
      subject
      users = User.all.limit(2)
      expect(users.map(&:username)).to eq(['new_user'])
      expect(users.map(&:name)).to eq(['New User'])
    end

    it 'creates a new person with the given name' do
      expect(Person.all).to eq([])
      subject
      expect(Person.all.map(&:name)).to eq(['New User'])
    end

    it 'creates a new profile with the given name as the title' do
      expect(Profile.all).to eq([])
      user = subject
      expect(Profile.all.map(&:title)).to eq(['New User'])
    end
  end
end
