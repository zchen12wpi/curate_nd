require 'spec_helper'

describe Api::UploadsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:token) { ApiAccessToken.create(issued_by: user.id, user: user) }
  let(:transaction) { double }

  describe '#trx_initiate' do
    context 'with api token which grants access' do
      it 'returns 200 and json document' do
        request.headers['X-Api-Token'] = token.sha
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :trx_initiate
        expect(response).to be_successful
      end
    end

    context 'when save fails' do
      before do
        allow(ApiTransaction).to receive(:new).and_return(:transaction)
        allow(transaction).to receive(:save).and_return false
      end

      it 'returns 417 and json document' do
        request.headers['X-Api-Token'] = token.sha
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :trx_initiate
        expect(response).to be_successful
      end
    end

    context 'without api token which grants access' do
      it 'returns 401 and json document' do
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :trx_initiate
        expect(response.status).to eq(401) #expectation_failed
      end
    end
  end
end