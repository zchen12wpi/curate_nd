require 'spec_helper'

describe ActiveFedora::DelegateAttributes::AttributeRegistry do
  let(:context) { Object.new }
  let(:name) { "My Name" }
  let(:options) { {} }
  subject { ActiveFedora::DelegateAttributes::AttributeRegistry.new(context) }

  describe '#register' do
    it 'yields an attribute' do
      @name = nil
      subject.register(name, options) do |attribute|
        @name = attribute.name
      end
      expect(@name).to eq(name)
    end
    it 'stores the attribute' do
      subject.register(name, options)
      expect(subject.fetch(name)).to be_kind_of(ActiveFedora::DelegateAttributes::Attribute)
    end
  end
  describe 'editable and displayable attributes' do
    let(:editable_options) { { editable: true, displayable: false } }
    let(:displayable_options) { { editable: false, displayable: true } }
    let(:default_options) { {} }

    before(:each) do
      @editable_attribute = subject.register('editable', editable_options)
      @displayable_attribute = subject.register('displayable', displayable_options)
      @default_attribute = subject.register('default', default_options)
    end
    it 'has #editable_attributes derived from registered inputs' do
      expect(subject.editable_attributes).to eq([@editable_attribute, @default_attribute])
    end
    it 'has #displayable_attributes derived from registered inputs' do
      expect(subject.displayable_attributes).to eq([@displayable_attribute, @default_attribute])
    end
  end
  describe '#attribute_defaults' do
    xit "assigns default on registry's context context"
  end
  describe '#attribute_config' do
    xit "assigns default on registry's context context"
  end
  describe '#input_options_for' do
    xit "returns input options"
  end
  describe '#label_for' do
    xit "handles forms"
  end
end
