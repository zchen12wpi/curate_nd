shared_examples 'has_common_solr_fields' do
  let(:solr_doc) { subject.to_solr }

  it "should index concrete an abstract type" do
    expect(subject.human_readable_type).to eq(solr_doc['human_readable_type_sim'])
    expect(solr_doc['generic_type_sim']).to contain_exactly('Work')
  end

end
