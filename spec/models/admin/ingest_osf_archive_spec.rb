require 'spec_helper'

describe Admin::IngestOSFArchive do
  let(:attributes) do
    {
      project_identifier: 'id',
      administrative_unit: 'admin unit',
      owner: 'owner',
      affiliation: 'affiliation'
    }
  end
  let(:ingest_osf_archive) { described_class.new(attributes) }
  subject { ingest_osf_archive }

  [:project_identifier, :administrative_unit, :owner, :affiliation].each do |attribute|
    it "is invalid when #{attribute} is not present" do
      attributes.delete(attribute)
      subject.should_not be_valid
    end
  end

  context '#as_hash' do
    let(:ingest_osf_archive) { described_class.new(attributes) }
    subject { ingest_osf_archive.as_hash }
    it { is_expected.to be_a(Hash) }
    it "is expected to equal the input attributes along with the project_url" do
      expect(subject).to eq(attributes.merge(project_url: ingest_osf_archive.project_url))
    end
    it "is expected to include the :project_url key" do
      expect(subject.keys).to include(:project_url)
    end
  end

  context '#==' do
    it 'compares on the objects #as_hash' do
      object_1 = described_class.new(attributes).as_hash
      object_2 = described_class.new(attributes).as_hash
      object_3 = described_class.new({}).as_hash
      expect(object_1).to eq(object_2)
      expect(object_2).to_not eq(object_3)
    end
  end

  context '#build_with_id_or_url' do
    let(:subject){ Admin::IngestOSFArchive.build_with_id_or_url(attributes) }

    it 'uses the id as is when it does not match a url' do
      attributes[:project_identifier] = 'theid'
      expect(subject.project_identifier).to eq('theid')
    end

    it 'uses the id as is when it does not match the two slashes' do
      attributes[:project_identifier] = 'http:/hostname/theid'
      expect(subject.project_identifier).to eq('http:/hostname/theid')
    end

    it 'uses the id as is when it does not have a scheme' do
      attributes[:project_identifier] = 'hostname/theid'
      expect(subject.project_identifier).to eq('hostname/theid')
    end

    it 'matches http' do
      attributes[:project_identifier] = 'http://hostname/theid'
      expect(subject.project_identifier).to eq('theid')
    end

    it 'matches https' do
      attributes[:project_identifier] = 'https://hostname/theid'
      expect(subject.project_identifier).to eq('theid')
    end

    it 'matches with trailing slash' do
      attributes[:project_identifier] = 'http://hostname/theid/'
      expect(subject.project_identifier).to eq('theid')
    end

    it 'matches with additional path' do
      attributes[:project_identifier] = 'http://hostname/theid/other/stuff'
      expect(subject.project_identifier).to eq('theid')
    end

    it 'matches when id is blank' do
      attributes[:project_identifier] = 'http://hostname//other/stuff'
      expect(subject.project_identifier).to eq('')
    end

    it 'matches when the port is given' do
      attributes[:project_identifier] = 'http://hostname:8080/theid/other/stuff'
      expect(subject.project_identifier).to eq('theid')
    end

    it 'matches when full authority is given' do
      attributes[:project_identifier] = 'http://user:pass@hostname.com:8080/theid'
      expect(subject.project_identifier).to eq('theid')
    end

    it 'matches when full authority and additional path is given' do
      attributes[:project_identifier] = 'http://user:pass@hostname.com:8080/theid/other/stuff/'
      expect(subject.project_identifier).to eq('theid')
    end
  end
end
