require 'spec_helper'

describe AntiVirusScanner do
  let(:object) { GenericFile.new }
  let(:file_path) { __FILE__ }
  subject { AntiVirusScanner.new(object, file_path) }
  let(:always_clean_scanner) { lambda {|o| 0 } }
  let(:always_has_virus_scanner) { lambda {|o| 1 } }
  describe '#call' do
    it 'returns true if anti-virus is successful' do
      subject.scanner_function = always_clean_scanner
      expect(subject.call).to eq(true)
    end

    it 'raise an exception if anti-virus failed' do
      subject.scanner_function = always_has_virus_scanner
      expect(subject.call).to eq(false)
    end
  end
end