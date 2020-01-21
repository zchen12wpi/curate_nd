shared_examples 'is_an_authority_group_class' do |described_class, group_to_create|
  context 'instance methods' do
    subject { described_class.new }
    it { is_expected.to respond_to(:authority_group) }
    it { is_expected.to respond_to(:usernames) }
  end

  context 'class methods' do
    subject { described_class }
    it { is_expected.to respond_to(:initialize_usernames) }
    it { should be_const_defined(:AUTH_GROUP_NAME) }
  end

  it_behaves_like 'is_an_authority_group'

  context '.usernames' do
    it 'is empty if authority group does not exist' do
      expect(described_class.new.usernames).to eq []
    end

    describe 'with an authority group' do
      let(:user) { double(username: username) }
      let(:username) { 'some_random_user' }
      let!(:authority_group) { FactoryGirl.create(group_to_create, authorized_usernames: username) }

      it 'usernames includes authorized user' do
        expect(described_class.new.usernames).to include(user.username)
      end
    end
  end
end
