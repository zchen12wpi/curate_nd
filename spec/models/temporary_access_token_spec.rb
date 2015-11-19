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
    it 'permits a null SHA during object initialization' do
      token = FactoryGirl.build(:temporary_access_token, sha: nil)
      expect(token.sha).to eq(nil)
    end

    it 'sets a SHA during object persistence' do
      token = FactoryGirl.create(:temporary_access_token, sha: nil)
      expect(token.sha).not_to eq(nil)
    end

    it 'ignores SHA values passed during object initialization' do
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

    it 'should allow access to existing, unused tokens' do
      subject.save!
      expect(TemporaryAccessToken.count).not_to eq(0)
      expect(TemporaryAccessToken.permitted?(subject.noid, subject.sha)).to eq(true)
    end

    it 'should set a expiry date the first time it has been used' do
      subject.save!
      expect(subject.expiry_date).to be_nil
      expect(TemporaryAccessToken.use!(subject.sha)).to eq(true)
      updated_token = TemporaryAccessToken.find(subject.sha)
      expect(updated_token.expiry_date).to_not be_nil
    end

    it 'should not change the expiry date if the token is used repeatedly' do
      expected_expiry_date = Time.now + 1.hour
      subject.expiry_date = expected_expiry_date
      subject.save!
      expect(TemporaryAccessToken.use!(subject.sha)).to eq(false)
      expect(subject.expiry_date).to eq(expected_expiry_date)
    end

    it 'should permit access with a token to be used repeatedly before the expiry period has elapsed' do
      subject.expiry_date = Time.now + 1.hour
      subject.save!
      expect(TemporaryAccessToken.permitted?(subject.noid, subject.sha)).to eq(true)
      expect(TemporaryAccessToken.permitted?(subject.noid, subject.sha)).to eq(true)
    end

    it 'should not permit access with a token after the expiry period has elapsed' do
      subject.expiry_date = Time.now - 1.hour
      subject.save!
      expect(TemporaryAccessToken.permitted?(subject.noid, subject.sha)).to eq(false)
    end

    it 'should not be able to update the expiry date of a token with an unknown sha' do
      expect(TemporaryAccessToken.use!('sha_that_does_not_exist')).to eq(false)
    end
  end
end
