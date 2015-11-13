require 'spec_helper'

describe TemporaryAccessToken do
  let(:attributes) {{ noid: '1a2b3c4d', issued_by: 'ralph' }}

  context 'test support' do
    subject { FactoryGirl.build(:temporary_access_token, attributes) }
    it 'has a valid factory' do
      expect(subject).to be_valid
    end
  end

  context 'issuing new tokens' do
    describe ':sha is created automatically' do
      it 'permits a null sha during object initialization' do
        token = FactoryGirl.build(:temporary_access_token, sha: nil)
        expect(token.sha).to eq(nil)
      end

      it 'sets a sha during object persistance' do
        token = FactoryGirl.create(:temporary_access_token, sha: nil)
        expect(token.sha).not_to eq(nil)
      end

      it 'ignores sha values passed during object initialization' do
        provided_sha = 'please_ignore_this_sha'
        token = FactoryGirl.create(:temporary_access_token, sha: provided_sha)
        expect(token.sha).not_to eq(provided_sha)
      end
    end
  end

  # Class Method :permitted?
  # Class Method :expire!
end
