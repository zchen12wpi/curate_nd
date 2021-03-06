require 'spec_helper'

describe Api::ItemsController do
  let(:public_article) { FactoryGirl.create(:public_article, title: 'Fried Green Tomatoes',) }
  let(:private_article) { FactoryGirl.create(:article, title: 'All About Cats', user: user) }
  let(:private_work) { FactoryGirl.create(:private_generic_work, title: 'More About Cats', user: user) }
  let(:generic_file) { FactoryGirl.create(:generic_file, user: user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:token) { ApiAccessToken.create(issued_by: user.id, user: user) }

  describe '#show' do
    context 'with api token which grants access' do
      it 'returns 200 and json document' do
        request.headers['X-Api-Token'] = token.sha
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :show, { id: private_work.to_param }
        expect(response).to be_successful
      end
    end

    context 'with invalid api token' do
      it 'returns 403 and json document for private work' do
        request.headers['X-Api-Token'] = 'abc'
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :show, { id: private_work.to_param }
        expect(response).to be_forbidden
      end

      it 'returns 200 and json document for public work' do
        request.headers['X-Api-Token'] = 'abc'
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :show, { id: public_article.to_param }
        expect(response).to be_successful
      end
    end

    context 'without api token' do
      it 'returns 403 and json document' do
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :show, { id: private_work.to_param }
        expect(response).to be_forbidden
      end

      it 'returns 200 and json document for public work' do
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :show, { id: public_article.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe '#index' do
    before do
      public_article
      private_article
      private_work
    end

    context 'with no search parameters' do
      it 'includes all authorized works, and returns status 200 with first page of results in expected json format' do
        request.headers['X-Api-Token'] = token.sha
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :index
        expect(response).to be_successful
        json = JSON.parse(response.body)

        expect(json['pagination']['totalResults']).to eq(3)
        expect(json.keys).to eq(["query", "results", "pagination"])
        expect(json['query'].keys).to eq(["queryUrl", "queryParameters"])
        expect(json['results']).to be_a Array
        expect(json['results'].first.keys).to include("id", "title", "type", "itemUrl")
        expect(json['pagination'].keys).to include("itemsPerPage", "totalResults", "currentPage", "firstPage", "lastPage")
      end
    end

    context 'with valid search parameters' do
      it 'recognizes searches for valid search terms, filters returned data, and includes terms in results' do
        request.headers['X-Api-Token'] = token.sha
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :index, { type: 'Article', editor: "self", depositor: "self" }
        expect(response).to be_successful
        json = JSON.parse(response.body)

        expect(json['pagination']['totalResults']).to eq(1)
        expect(json['results'].first.keys).to include("type", "editor", "depositor")
        expect(json['query']['queryParameters'].keys).to include("type", "editor", "depositor")
      end

      it 'disallows search for self if no token' do
        request.headers['HTTP_ACCEPT'] = "application/json"
        get :index, { type: 'Article', editor: "self", depositor: "self" }
        expect(response).to be_bad_request
      end
    end

    context 'with date filtering' do
      context 'when dates are formatted correctly' do
        let(:requested_date) { "after:2019-01-01" }

        it 'searches dates and includes dates in the search results list' do
          request.headers['X-Api-Token'] = token.sha
          request.headers['HTTP_ACCEPT'] = "application/json"
          get :index, { deposit_date: requested_date, modify_date: requested_date }
          expect(response).to be_successful
          json = JSON.parse(response.body)

          expect(json['pagination']['totalResults']).to eq(3)
          expect(json['results'].first.keys).to include("depositDate", "modifyDate")
          expect(json['query']['queryParameters'].keys).to include("deposit_date", "modify_date")
        end
      end

      context 'when date formatting is incorrect' do
        context 'with bad date format' do
          let(:requested_date) { "after:2019-01-01,before:2020-01-0" }

          it 'returns a bad request' do
            request.headers['X-Api-Token'] = token.sha
            request.headers['HTTP_ACCEPT'] = "application/json"
            get :index, { deposit_date: requested_date }
            expect(response).to be_bad_request
          end
        end

        context 'with bad before/after term' do
          let(:requested_date) { "after:2019-01-01,befor:2020-01-01" }

          it 'returns a bad request' do
            request.headers['X-Api-Token'] = token.sha
            request.headers['HTTP_ACCEPT'] = "application/json"
            get :index, { deposit_date: requested_date }
            expect(response).to be_bad_request
          end
        end
      end
    end
  end

  describe '#token' do
    context 'with a valid request' do
      it 'returns 200 and a json document' do
        request.headers['X-Api-Token'] = token
        request.headers['HTTP_ACCEPT'] = "application/json"
        post :token, { id: generic_file.to_param }
        expect(response).to be_successful
      end
    end
    context 'with an invalid request' do
      it 'returns 400 and a json document' do
        request.headers['X-Api-Token'] = token
        request.headers['HTTP_ACCEPT'] = "application/json"
        post :token, { id: private_article.to_param }
        expect(response).to be_bad_request
      end
    end
  end
end
