shared_examples 'is_an_authority_group' do
  let(:described_class) { Admin::AuthorityGroup }

  context 'instance methods' do
    let(:subject) { described_class.new }
    it { is_expected.to respond_to(:usernames) }
    it { is_expected.to respond_to(:reload_authorized_usernames) }
    it { is_expected.to respond_to(:valid_group_pid?) }
    it { is_expected.to respond_to(:associated_group) }
    it { is_expected.to respond_to(:initial_user_list) }
    it { is_expected.to respond_to(:formatted_initial_list) }
    it { is_expected.to respond_to(:destroyable?) }
    it { is_expected.to respond_to(:class_exists?) }
  end

  context 'class methods' do
    let(:subject) { described_class}
    it { is_expected.to respond_to(:authority_group_for) }
    it { is_expected.to respond_to(:initialize_usernames) }
  end
end
