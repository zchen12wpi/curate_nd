require 'spec_helper'

describe AlephIdentifierValidator do

  let(:validatable) do
    Class.new do
      def self.name
        'Validatable'
      end
      include ActiveModel::Validations
      attr_accessor :aleph_identifier
      validates :aleph_identifier, aleph_identifier: true
    end
  end

  subject { validatable.new }

  before do
    subject.aleph_identifier = aleph_identifier
    subject.valid?
  end

  context 'extrainous whitespace' do
    let(:aleph_identifier) { [
      ' 123456',
      '123456 ',
      ' 123456 '
    ] }
    it { expect(subject.errors.messages).to eq :aleph_identifier => [
      described_class::WHITESPACE_ERROR_MESSAGE,
      described_class::WHITESPACE_ERROR_MESSAGE,
      described_class::WHITESPACE_ERROR_MESSAGE
    ] }
  end

  context 'valid Catalog numbers' do
    let(:aleph_identifier) do
      [ '123123123',
        '345678900',
        '123123123'
      ]
    end
    it { expect(subject.errors.messages).to eq({}) }
  end

  context 'Invalid Aleph Identifier Number numbers' do
    let(:aleph_identifier) do
      [
        '9971-5-0210-09',
        '960-425-059',
        'ABCABCABC',
        '123456',
        '11111'
      ]
    end
    it { expect(subject.errors.messages).to eq :aleph_identifier => [
      described_class::FORMAT_ERROR_MESSAGE,
      described_class::FORMAT_ERROR_MESSAGE,
      described_class::FORMAT_ERROR_MESSAGE,
      described_class::FORMAT_ERROR_MESSAGE,
      described_class::FORMAT_ERROR_MESSAGE
    ] }
  end

end
