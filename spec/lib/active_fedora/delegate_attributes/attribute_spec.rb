require 'spec_helper'

describe ActiveFedora::DelegateAttributes::Attribute do
  let(:name) { :title }
  let(:datastream) { 'SourApple' }
  let(:validation_options) {{ presence: true }}
  let(:options) {
    {
      datastream: datastream, hint: 'Your title',
      form: { input_html: {style: 'title-picker'}},
      displayable: true,
      editable: true,
      validates: validation_options
    }
  }
  subject { ActiveFedora::DelegateAttributes::Attribute.new(name, options) }

  its (:displayable?) { should be_true }
  its (:editable?) { should be_true }

  it 'has #options_for_input' do
    expect(subject.options_for_input(input_html: {size: 10})).to eq(
      {
        hint: 'Your title', as: 'multi_value', input_html:
        {
          style: 'title-picker', multiple: 'multiple', size: 10
        }
      }
    )
  end

  it 'yields name and options for #validations' do
    @yielded = false
    subject.with_validation_options do |name, opts|
      expect(name).to eq(name)
      expect(opts).to eq(validation_options)
      @yielded = true
    end
    expect(@yielded).to eq(true)
  end

  describe 'with datastream' do

    it 'yields name and options for #delegation' do
      @yielded = false
      subject.with_delegation_options {|name,opts|
        @yielded = true
        expect(name).to eq(name)
        expect(opts).to eq(subject.send(:options_for_delegation))
      }
      expect(@yielded).to eq(true)
    end

    it 'does not yield name nor options for #accession' do
      @yielded = false
      subject.with_accession_options {|name,opts|
        @yielded = true
      }
      expect(@yielded).to eq(false)
    end

  end

  describe 'without datastream' do
    let(:datastream) { nil }
    it 'does not yield name and options for #delegation' do
      @yielded = false
      subject.with_delegation_options {|name,opts|
        @yielded = true
      }
      expect(@yielded).to eq(false)
    end

    it 'yields name nor options for #accession' do
      @yielded = false
      subject.with_accession_options {|name,opts|
        @yielded = true
        expect(name).to eq(name)
        expect(opts).to eq({})
      }
      expect(@yielded).to eq(true)
    end

  end
end
