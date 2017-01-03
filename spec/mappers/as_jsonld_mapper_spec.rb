require 'spec_helper'

describe AsJsonldMapper do
  # Addresses https://jira.library.nd.edu/browse/DLTP-751
  # http://json-ld.org/spec/latest/json-ld/#named-graphs
  it 'compresses the keys into @context and @graph if @graph is present' do
    etd = FactoryGirl.create(:etd)
    output = described_class.call(etd)
    expect(output.keys).to eq(['@context', '@graph'])
    expect(output.fetch("@graph").size).to eq(3)
  end

  it 'compresses the keys into @context and @graph if @graph is present' do
    document = FactoryGirl.create(:document)
    output = described_class.call(document)
    expect(output.keys.sort).to eq([
      '@context',
      '@id',
      'nd:afmodel',
      'nd:depositor',
      "nd:accessReadGroup",
      "nd:accessEdit",
      "dc:abstract",
      "dc:created",
      "dc:creator",
      "dc:dateSubmitted",
      "dc:modified",
      "dc:rights",
      "dc:title",
      "dc:type"
    ].sort)
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) { FactoryGirl.create_curation_concern(:article, user) }
  let(:generic_file) { FactoryGirl.create_generic_file(curation_concern, user) }

  let(:expected_article_json) do
    {
      "@id"=>"#{curation_concern.id}",
      "nd:afmodel"=>"#{curation_concern.class.name}",
      "nd:depositor"=>"#{user.username}",
      "nd:accessReadGroup"=>"registered",
      "nd:accessEdit"=>"#{user.username}",
      "dc:abstract"=>"#{curation_concern.abstract}",
      "dc:created"=>"#{curation_concern.date_modified.strftime("%F")}",
      "dc:creator#author"=>"#{curation_concern.creator.to_sentence}",
      "dc:dateSubmitted"=>{"@value"=>"#{curation_concern.date_uploaded.strftime("%FZ")}", "@type"=>"http://www.w3.org/2001/XMLSchema#date"},
      "dc:language"=>"#{curation_concern.language.to_sentence}",
      "dc:modified"=> {"@value"=>"#{curation_concern.date_modified.strftime("%FZ")}", "@type"=>"http://www.w3.org/2001/XMLSchema#date"},
      "dc:rights"=>"#{curation_concern.rights}",
      "dc:title"=>"#{curation_concern.title}"
    }
  end

  let(:expected_generic_file_json) do
    {
      "@id"=>"#{generic_file.id}",
      "nd:afmodel"=>"#{generic_file.class.name}",
      "dc:dateSubmitted"=> {"@value"=>"#{generic_file.date_uploaded.strftime("%FZ")}", "@type"=>"http://www.w3.org/2001/XMLSchema#date"},
      "dc:modified"=> {"@value"=>"#{generic_file.date_modified.strftime("%FZ")}", "@type"=>"http://www.w3.org/2001/XMLSchema#date"},
      "frels:isPartOf" => {"@id" => curation_concern.id},
      "nd:accessEdit" => "#{user.username}",
      "nd:content" => File.join(Rails.configuration.application_root_url, '/downloads/', generic_file.noid),
      "nd:depositor" => "#{user.username}",
      "nd:filename" => "#{generic_file.filename}",
      "nd:mimetype" => "#{generic_file.content.mimeType}",
      "nd:owner" => "#{user.username}",
      "nd:thumbnail" => {"@id"=>File.join(Rails.configuration.application_root_url, '/downloads/', generic_file.noid, '/thumbnail').to_s}
    }
  end

  it 'will instantiate then call the instance' do
    expect(described_class).to receive(:new).and_return(double(call: true))
    described_class.call(curation_concern)
  end

  context 'convert all article datastreams into json'do
    subject { described_class.new(curation_concern).call.except("@context") }
    it { is_expected.to eq(expected_article_json) }
  end

  context 'convert all generic file datastreams into json'do
    subject { described_class.new(generic_file).call.except("@context") }
    it { is_expected.to eq(expected_generic_file_json) }
  end

end
