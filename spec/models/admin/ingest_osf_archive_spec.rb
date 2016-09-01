require 'spec_helper'

describe Admin::IngestOSFArchive do
  let(:attributes) do
    {
      project_identifier: 'id',
      administrative_unit: 'admin unit',
      owner: 'owner',
      affiliation: 'affiliation',
      status: 'status'
    }
  end
  let(:subject){ Admin::IngestOSFArchive.new(attributes) }

  [:project_identifier, :administrative_unit, :owner, :affiliation].each do |attribute|
    it "is invalid when #{attribute} is not present" do
      attributes.delete(attribute)
      subject.should_not be_valid
    end
  end

  describe '#build_with_id_or_url' do
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
