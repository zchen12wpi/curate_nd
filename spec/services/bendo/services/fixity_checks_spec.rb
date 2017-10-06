require 'fast_spec_helper'
require 'bendo/services/fixity_checks'
require 'webmock/rspec'

module Bendo
  module Services
    RSpec.describe FixityChecks do
      let(:api_key) { "api_key" }
      let(:fixity_url) { "http://localhost/fixity_url" }
      let(:fake_response_hash) { [ { "a" => "a", "b" => "b" } ] }
      let(:fake_response) { fake_response_hash.to_json }

      before(:each) do
        allow(Bendo).to receive(:api_key).and_return(api_key)
        allow(Bendo).to receive(:fixity_url).and_return(fixity_url)
      end

      describe '.call' do
        context 'for all requests to bendo' do
          subject { described_class.call(params: {}) }

          before(:each) do
            stub_request(:any, fixity_url).to_return(status: 200, body: fake_response)
          end

          it 'performs a GET to the API at the url from the Bendo module' do
            allow(Bendo).to receive(:fixity_url).and_return('http://some.where.com')
            stub_request(:any, 'http://some.where.com').to_return(status: 200, body: fake_response)
            subject
            expect(WebMock).to have_requested(:get, 'http://some.where.com')
          end

          it 'calls bendo with the api key' do
            subject
            expect(WebMock).to have_requested(:get, fixity_url).with(headers: { 'X-Api-Key' => api_key })
          end
        end

        context 'when a 200 is returned from bendo' do
          subject { described_class.call(params: {}) }

          before(:each) do
            stub_request(:any, fixity_url).to_return(status: 200, body: fake_response)
          end

          it 'returns 200' do
            expect(subject.status).to eq(200)
          end

          it 'returns the results from bendo as a hash' do
            expect(subject.body).to eq(fake_response_hash)
          end
        end

        context 'when a 200 is not returned from bendo' do
          subject { described_class.call(params: {}) }

          before(:each) do
            stub_request(:any, fixity_url).to_return(status: 400, body: fake_response)
          end

          it 'passes the bendo status through to the response' do
            expect(subject.status).to eq(400)
          end

          it 'returns the results from bendo as is' do
            expect(subject.body).to eq(fake_response)
          end
        end

        context 'with no parameters' do
          subject { described_class.call(params: {}) }

          before(:each) do
            stub_request(:any, fixity_url).to_return(status: 200, body: fake_response)
          end

          it 'calls bendo with no params' do
            subject
            expect(WebMock).to have_requested(:get, fixity_url).with(query: '')
          end
        end

        context 'with parameters' do
          let(:params) do
            { "item" => "item", "status" => "status", "scheduled_time_start" => "start", "scheduled_time_end" => "end" }
          end
          let(:remapped_params) do
            { "item" => "item", "status" => "status", "start" => "start", "end" => "end" }
          end
          subject { described_class.call(params: params) }

          before(:each) do
            stub_request(:any, fixity_url).with(query: remapped_params).to_return(status: 200, body: fake_response)
          end

          it 'calls bendo with remapped params' do
            subject
            expect(WebMock).to have_requested(:get, fixity_url).with(query: remapped_params)
          end
        end
      end
    end
  end
end
