require 'spec_helper'

describe TemporaryAccessToken do
  let(:attributes) {{ noid: '1a2b3c4d', issued_by: 'ralph' }}

  context 'test support' do
    subject { FactoryGirl.build(:temporary_access_token, attributes) }
    it 'has a valid factory' do
      expect(subject).to be_valid
    end
  end

  context 'when being created' do
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

    it 'ignores pid namespace passed during object initialization' do
      provided_pid = 'und:1234'
      implied_noid = '1234'
      token = FactoryGirl.create(:temporary_access_token, noid: provided_pid)
      expect(token.noid).to eq(implied_noid)
    end
  end

    context 'when validating existing tokens' do
    subject { FactoryGirl.create(:temporary_access_token, attributes) }

    it 'should allow access exisiting, unused tokens' do
      subject.save!
      expect(TemporaryAccessToken.count).not_to eq(0)
      expect(TemporaryAccessToken.permitted?(subject.noid, subject.sha)).to eq(true)
    end

    it 'should not allow access exisiting, used tokens' do
      subject.used = true
      subject.save!
      expect(TemporaryAccessToken.count).not_to eq(0)
      expect(TemporaryAccessToken.permitted?(subject.noid, subject.sha)).to eq(false)
    end

    it 'should not allow access to a token after it has been expired' do
      subject.save!
      expect(TemporaryAccessToken.count).not_to eq(0)
      expect(TemporaryAccessToken.permitted?(subject.noid, subject.sha)).to eq(true)
      expect(TemporaryAccessToken.expire!(subject.sha)).to eq(true)
      expect(TemporaryAccessToken.permitted?(subject.noid, subject.sha)).to eq(false)
    end

    it 'should not be able to expire a used token' do
      subject.used = true
      subject.save!
      expect(TemporaryAccessToken.expire!(subject.sha)).to eq(false)
    end

    it 'should not be able to expire a token with an unknown sha' do
      expect(TemporaryAccessToken.expire!('sha_that_does_not_exist')).to eq(false)
    end
  end
end
