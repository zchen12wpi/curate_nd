shared_examples 'with_json_mapper' do
  context 'behavior' do
    subject { described_class.new }
      it { is_expected.to respond_to(:as_jsonld) }
  end
end
