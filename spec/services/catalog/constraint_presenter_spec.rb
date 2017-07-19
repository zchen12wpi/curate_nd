require 'spec_helper'

RSpec.describe Catalog::ConstraintPresenter::ProxyDecorator do
  describe '.call' do
    it 'strips script tags' do
      expect(described_class.call("<script>alert(150)</script>")).to eq('')
    end

    it 'leaves HTML alone' do
      expect(described_class.call("<div>Hello</div>")).to eq("&lt;div&gt;Hello&lt;/div&gt;")
    end
  end
end
