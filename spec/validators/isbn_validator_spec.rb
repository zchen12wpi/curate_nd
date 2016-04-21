require 'spec_helper'

describe IsbnValidator do

  let(:validatable) do
    Class.new do
      def self.name
        'Validatable'
      end
      include ActiveModel::Validations
      attr_accessor :isbn_numbers
      validates :isbn_numbers, isbn: true
    end
  end
  subject { validatable.new }

  before do
    subject.isbn_numbers = isbn_numbers
    subject.valid?
  end

  context 'extrainous whitespace' do
    let(:isbn_numbers) { [
      ' 0-9752298-0-X',
      '0-9752298-0-X ',
      ' 0-9752298-0-X '
    ] }
    it { expect(subject.errors.messages).to eq :isbn_numbers => [
      'Cannot have leading or trailing spaces',
      'Cannot have leading or trailing spaces',
      'Cannot have leading or trailing spaces'
    ] }
  end

  context 'valid ISBN numbers' do
    let(:isbn_numbers) do
      [
        '978-1-56619-909-4',
        '9781566199094',
        '1-56619-909-3',
        '1566199093',
        '80-902734-1-6',
        '99921-58-10-7',
        '978-0-306-40615-7',
        '9971-5-0210-0',
        '99921-58-10-7',
        '9971-5-0210-0',
        '960-425-059-0',
        '80-902734-1-6',
        '85-359-0277-5',
        '1-84356-028-3',
        '0-684-84328-5',
        '0-8044-2957-X',
        '0-85131-041-9',
        '0-943396-04-2',
        '0-9752298-0-X'
      ]
    end
    it { expect(subject.errors.messages).to eq({}) }
  end

  context 'invalid ISBN numbers' do
    let(:isbn_numbers) do
      [
        '78-1-561x9-909-4'
      ]
    end
    it { expect(subject.errors.messages).to eq :isbn_numbers => [
      'Invalid ISBN'
    ] }
  end

end
