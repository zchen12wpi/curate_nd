require 'spec_helper'

RSpec.describe DatastreamJsonMapper do

  def strip_namespace(pid)
    String(pid).split(":").last
  end
  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) {
    FactoryGirl.create_curation_concern(:article, user)
  }
  let(:generic_file) { FactoryGirl.create_generic_file(curation_concern, user) }

  let(:expected_article_json){
    {"@context"=> {"und"=>File.join(Rails.configuration.application_root_url, '/show/').to_s,
                   "bibo"=>"http://purl.org/ontology/bibo/",
                   "dc"=>"http://purl.org/dc/terms/",
                   "ebucore"=>"http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#",
                   "foaf"=>"http://xmlns.com/foaf/0.1/",
                   "mrel"=>"http://id.loc.gov/vocabulary/relators/",
                   "nd"=>"https://library.nd.edu/ns/terms/",
                   "rdfs"=>"http://www.w3.org/2000/01/rdf-schema#",
                   "vracore"=>"http://purl.org/vra/",
                   "frels"=>"info:fedora/fedora-system:def/relations-external#",
                   "ms"=>"http://www.ndltd.org/standards/metadata/etdms/1.1/",
                   "fedora-model"=>"info:fedora/fedora-system:def/model#",
                   "hydra"=>"http://projecthydra.org/ns/relations#",
                   "hasModel"=> {"@id"=>"fedora-model:hasModel", "@type"=>"@id"},
                   "hasEditor"=> {"@id"=>"hydra:hasEditor", "@type"=>"@id"},
                   "hasEditorGroup"=> {"@id"=>"hasEditor:Group", "@type"=>"@id"},
                   "isPartOf"=> {"@id"=>"frels:isPartOf", "@type"=>"@id"},
                   "isMemberOfCollection"=> {"@id"=>"frels:isMemberOfCollection", "@type"=>"@id"},
                   "isEditorOf"=> {"@id"=>"hydra:isEditorOf", "@type"=>"@id"},
                   "hasMember"=> {"@id"=>"frels:hasMember", "@type"=>"@id"},
                   "previousVersion"=>"http://purl.org/pav/previousVersion"},
     "@id"=>"#{curation_concern.id}",
     "nd:afmodel"=>"#{curation_concern.class.name}",
     "nd:depositor"=>"#{user.username}",
     "nd:accessReadGroup"=>["registered"],
     "nd:accessEdit"=>["#{user.username}"],
     "dc:abstract"=>"#{curation_concern.abstract}",
     "dc:created"=>"#{curation_concern.date_modified.strftime("%F")}",
     "dc:creator#author"=>"#{curation_concern.creator.to_sentence}",
     "dc:dateSubmitted"=>{"@value"=>"#{curation_concern.date_uploaded.strftime("%FZ")}", "@type"=>"http://www.w3.org/2001/XMLSchema#date"},
     "dc:language"=>"#{curation_concern.language.to_sentence}",
     "dc:modified"=> {"@value"=>"#{curation_concern.date_modified.strftime("%FZ")}", "@type"=>"http://www.w3.org/2001/XMLSchema#date"},
     "dc:rights"=>"#{curation_concern.rights}",
     "dc:title"=>"#{curation_concern.title}"
    }
  }

  let(:expected_generic_file_json){
    {"@context"=> {"und"=>File.join(Rails.configuration.application_root_url, '/show/').to_s,
                   "bibo"=>"http://purl.org/ontology/bibo/",
                   "dc"=>"http://purl.org/dc/terms/",
                   "ebucore"=>"http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#",
                   "foaf"=>"http://xmlns.com/foaf/0.1/",
                   "mrel"=>"http://id.loc.gov/vocabulary/relators/",
                   "nd"=>"https://library.nd.edu/ns/terms/",
                   "rdfs"=>"http://www.w3.org/2000/01/rdf-schema#",
                   "vracore"=>"http://purl.org/vra/",
                   "frels"=>"info:fedora/fedora-system:def/relations-external#",
                   "ms"=>"http://www.ndltd.org/standards/metadata/etdms/1.1/",
                   "fedora-model"=>"info:fedora/fedora-system:def/model#",
                   "hydra"=>"http://projecthydra.org/ns/relations#",
                   "hasModel"=> {"@id"=>"fedora-model:hasModel", "@type"=>"@id"},
                   "hasEditor"=> {"@id"=>"hydra:hasEditor", "@type"=>"@id"},
                   "hasEditorGroup"=> {"@id"=>"hasEditor:Group", "@type"=>"@id"},
                   "isPartOf"=> {"@id"=>"frels:isPartOf", "@type"=>"@id"},
                   "isMemberOfCollection"=> {"@id"=>"frels:isMemberOfCollection", "@type"=>"@id"},
                   "isEditorOf"=> {"@id"=>"hydra:isEditorOf", "@type"=>"@id"},
                   "hasMember"=> {"@id"=>"frels:hasMember", "@type"=>"@id"},
                   "previousVersion"=>"http://purl.org/pav/previousVersion"},
     "@id"=>"#{generic_file.id}",
     "nd:afmodel"=>"#{generic_file.class.name}",
     "dc:dateSubmitted"=> {"@value"=>"#{generic_file.date_uploaded.strftime("%FZ")}", "@type"=>"http://www.w3.org/2001/XMLSchema#date"},
     "dc:modified"=> {"@value"=>"#{generic_file.date_modified.strftime("%FZ")}", "@type"=>"http://www.w3.org/2001/XMLSchema#date"},
     "isPartOf" => "#{curation_concern.id}",
     "nd:accessEdit" => ["#{user.username}"],
     "nd:content" => File.join(Rails.configuration.application_root_url, '/downloads/', strip_namespace(generic_file.pid)).to_s,
     "nd:depositor" => "#{user.username}",
     "nd:filename" => "#{generic_file.filename}",
     "nd:mimetype" => "#{generic_file.content.mimeType}",
     "nd:owner" => "#{user.username}",
     "nd:thumbnail" => {"@id"=>File.join(Rails.configuration.application_root_url, '/downloads/', strip_namespace(generic_file.pid), '/thumbnail').to_s}
    }
  }

  it 'will instantiate then call the instance' do
    expect(described_class).to receive(:new).and_return(double(call: true))
    described_class.call(curation_concern)
  end

  context 'convert all article datastreams into json'do
    subject do
      described_class.new(curation_concern).call
    end
    it { is_expected.to eq(expected_article_json) }
  end

  context 'convert all generic file datastreams into json'do
    subject do
      described_class.new(generic_file).call
    end
    it { is_expected.to eq(expected_generic_file_json) }
  end
end
