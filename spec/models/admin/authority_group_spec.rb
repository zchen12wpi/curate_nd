require 'spec_helper'

describe Admin::AuthorityGroup, type: :model do
  it_behaves_like 'is_an_authority_group'

  context 'behavior' do
    let(:subject) { described_class.new }
    let(:authorized_usernames) { "user1, user2, user3" }
    let(:hydramata_group) { FactoryGirl.create(:group) }
    let(:user) { double(username: 'user1') }
    let(:user2) { double(username: 'user2') }
    let(:person1) { double(user: user) }
    let(:person2) { double(user: user2) }
    let(:admin_authority_group) { FactoryGirl.create(:admin_grp, authorized_usernames: 'user1, user2') }
    let(:new_group) { described_class.new(
      auth_group_name: 'a_new_group',
      description: 'a group for testing',
      authorized_usernames: "user1, user2, user3"
      ) }

    describe '#usernames' do
      before do
        allow(subject).to receive(:authorized_usernames).and_return(authorized_usernames)
      end

      it 'splits string into comma-separated array' do
        expect(subject.usernames).to eq(['user1', 'user2', 'user3'])
      end
    end

    describe '#reload_authorized_usernames' do
      before do
        allow(subject).to receive(:associated_group).and_return(hydramata_group)
        allow(hydramata_group).to receive(:members).and_return [person1, person2]
      end

      it 'returns usernames from associated group' do
        list_of_usernames = subject.reload_authorized_usernames
        expect(list_of_usernames).to contain_exactly('user1', 'user2')
        expect(list_of_usernames).to be_a Array
      end
    end

    describe '#associated_group' do
      describe 'when a group exists' do
        before do
          allow(subject).to receive(:associated_group_pid).and_return(hydramata_group.id)
        end
        it 'finds an associated group if one exists' do
          expect(subject.associated_group).to be_a(Hydramata::Group)
        end
      end

      describe 'when there is no associated group' do
        it 'returns nil' do
          expect(subject.associated_group).to be nil
        end
      end
    end

    describe '#valid_group_pid?' do
      describe 'when empty' do
        before do
          allow(subject).to receive(:associated_group_pid).and_return ''
        end
        it 'is valid' do
          expect(subject.valid_group_pid?).to be_truthy
        end
      end
      describe 'when the group exists' do
        before do
          allow(subject).to receive(:associated_group_pid).and_return(hydramata_group.id)
        end
        it 'is valid' do
          expect(subject.valid_group_pid?).to be_truthy
        end
      end
      describe 'when it does not find the group' do
        before do
          allow(subject).to receive(:associated_group_pid).and_return 'abcde'
        end
        it 'is not valid' do
          expect(subject.valid_group_pid?).to be_falsey
        end
      end
    end

    describe '.authority_group_for' do
      before do
        admin_authority_group
      end
      it 'finds an authority group by name' do
        auth_group_name = Admin::AuthorityGroup::RepositoryAdministrator::AUTH_GROUP_NAME
        expect(described_class.authority_group_for(auth_group_name: auth_group_name)).to eq(admin_authority_group)
      end
      it 'returns nil if group is not found' do
        auth_group_name = 'another_name'
        expect(described_class.authority_group_for(auth_group_name: auth_group_name)).to eq nil
      end
    end

    describe '.initialize_usernames' do
      let(:yml_file) { 'config/admin_usernames.yml' }
      let(:key) { 'admin_usernames' }

      it 'accepts a yml file and returns an array' do
        subject = described_class.initialize_usernames(usernames_file: yml_file, file_key: key)
        expect(subject).to contain_exactly( ENV['USER'], "an_admin_username")
      end
      it 'returns an empty array if no usernames file given' do
        subject = described_class.initialize_usernames
        expect(subject).to eq([])
      end
    end

    describe '#initial_user_list' do
      it 'returns the list of usernames from yml' do
        expect(admin_authority_group.initial_user_list).to contain_exactly( ENV['USER'], "an_admin_username")
      end
      it 'returns an empty array if no controlling class' do
        expect(new_group.initial_user_list).to eq []
      end
    end

    describe '#formatted_initial_list' do
      it 'turns username array into a comma-separated string' do
        expect(admin_authority_group.formatted_initial_list).to eq "#{ENV['USER']}, an_admin_username"
      end
    end

    describe '#destroyable?' do
      let(:subject) { admin_authority_group.destroyable? }

      context 'authority group with valid controlling_class' do
        before do
          allow(admin_authority_group).to receive(:class_exists?).and_return true
        end
        it 'does not allow destruction' do
          expect(subject).to be_falsey
        end
    end
      context 'authority group with no valid controlling_class' do
        before do
          allow(admin_authority_group).to receive(:class_exists?).and_return false
        end
        it 'allows destruction' do
          expect(subject).to be_truthy
        end
      end
    end

    describe '#class_exists?' do
      it 'with valid controlling class' do
        expect(admin_authority_group.class_exists?).to be_truthy
      end
      it 'with invalid controlling class' do
        expect(new_group.class_exists?).to be_falsey
      end
    end
  end
end
