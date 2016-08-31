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
end
