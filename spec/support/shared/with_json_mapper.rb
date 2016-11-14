shared_examples 'with_json_mapper' do
  context 'behavior' do
    subject { described_class.new }
    it 'responds to method as_jsonld' do
      it { is_expected.to respond_to(:as_jsonld) }
    end
  end
end
