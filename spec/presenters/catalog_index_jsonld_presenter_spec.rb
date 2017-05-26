require 'spec_helper'

RSpec.describe CatalogIndexJsonldPresenter do
  let(:raw_response) { JSON.parse(File.read(Rails.root.join("spec/fixtures/DLTP-1014/dltp-1014.json"))) }
  let(:request_url) { 'http://test.host/catalog.json' }
  let(:query_parameters) { { } }
  let(:presenter) { described_class.new(raw_response, request_url, query_parameters) }

  describe '#as_jsonld' do
    subject { presenter.as_jsonld }
    it { is_expected.to be_a(Hash) }
    it 'returns a Ruby hash that is a JSON-LD document' do
      expected = {"@context"=>
        {"xsd"=>"http://www.w3.org/2001/XMLSchema#",
         "deri"=>"http://sindice.com/vocab/search#",
         "und"=>"http://localhost:3000/show/",
         "dc"=>"http://purl.org/dc/terms/",
         "deri:first"=>{"@type"=>"@id"},
         "deri:last"=>{"@type"=>"@id"},
         "deri:previous"=>{"@type"=>"@id"},
         "deri:next"=>{"@type"=>"@id"},
         "deri:itemsPerPage"=>{"@type"=>"xsd:integer"},
         "deri:totalResults"=>{"@type"=>"xsd:integer"}},
       "@graph"=>
        [{"@id"=>"http://test.host/catalog.json",
          "deri:itemsPerPage"=>2,
          "deri:totalResults"=>12,
          "deri:first"=>"http://test.host/catalog.json",
          "deri:last"=>"http://test.host/catalog.json?page=6",
          "deri:next"=>"http://test.host/catalog.json?page=2"},
         {"@id"=>"und:m039k356t2q", "dc:title"=>"Work1"},
         {"@id"=>"und:dr26xw4309w", "dc:title"=>"Work2"}]
      }
      expect(subject).to eq(expected)
    end
  end

  describe '#to_jsonld' do
    subject { presenter.to_jsonld }
    it { is_expected.to be_a(String) }
    it 'returns a JSON document that can be parsed to a Ruby hash' do
      expect(JSON.parse(subject)).to be_a(Hash)
    end
    it 'makes the correct (and pretty) NTriples' do
      expected = [
        %(<http://test.host/catalog.json> <http://sindice.com/vocab/search#first> <http://test.host/catalog.json> .),
        %(<http://test.host/catalog.json> <http://sindice.com/vocab/search#itemsPerPage> "2"^^<http://www.w3.org/2001/XMLSchema#integer> .),
        %(<http://test.host/catalog.json> <http://sindice.com/vocab/search#last> <http://test.host/catalog.json?page=6> .),
        %(<http://test.host/catalog.json> <http://sindice.com/vocab/search#next> <http://test.host/catalog.json?page=2> .),
        %(<http://test.host/catalog.json> <http://sindice.com/vocab/search#totalResults> "12"^^<http://www.w3.org/2001/XMLSchema#integer> .),
        %(<http://localhost:3000/show/m039k356t2q> <http://purl.org/dc/terms/title> "Work1" .),
        %(<http://localhost:3000/show/dr26xw4309w> <http://purl.org/dc/terms/title> "Work2" .)
      ]
      actual = JSON::LD::Reader.new(subject).dump(:ntriples).split("\n").sort
      expect(actual).to eq(expected.sort)
    end
  end
end

RSpec.describe CatalogIndexJsonldPresenter::Pager do
  let(:presenter) { CatalogIndexJsonldPresenter.new(response, request_url, query_parameters) }
  let(:request_url) { RDF::URI.new('http://test.host/catalog.json') }
  subject { described_class.new(presenter) }
  describe 'at the beginning of pagination' do
    let(:response) do
      { 'response' => { 'docs' => [], 'numFound' => 11, 'start' => 0 }, 'responseHeader' => { 'params' => { 'rows' => 2 } } }
    end
    let(:query_parameters) { { "somebody" => "to-love" } }

    its(:total_results) { is_expected.to eq(11) }
    its(:total_pages) { is_expected.to eq(6) }
    its(:start) { is_expected.to eq(0) }
    its(:page) { is_expected.to eq(1) }
    its(:items_per_page) { is_expected.to eq(2) }
    its(:first_page?) { is_expected.to eq(true) }
    its(:last_page?) { is_expected.to eq(false) }
    its(:prev_page) { is_expected.to eq(nil) }
    its(:next_page) { is_expected.to eq(2) }

    context '#pagination_url_for' do
      it 'will be the URL without page # for :first' do
        expect(subject.pagination_url_for(:first)).to eq("http://test.host/catalog.json?somebody=to-love")
      end
      it 'will be false for :previous' do
        expect(subject.pagination_url_for(:previous)).to eq(false)
      end
      it 'will be the URL with the next page for :next' do
        expect(subject.pagination_url_for(:next)).to eq("http://test.host/catalog.json?page=2&somebody=to-love")
      end
      it 'will be the URL with the last page for :last' do
        expect(subject.pagination_url_for(:last)).to eq("http://test.host/catalog.json?page=6&somebody=to-love")
      end
    end
  end

  describe 'in the middle of pagination' do
    let(:response) do
      { 'response' => { 'docs' => [], 'numFound' => 11, 'start' => 5 }, 'responseHeader' => { 'params' => { 'rows' => 2 } } }
    end
    let(:query_parameters) { { 'page' => 3, 'somebody' => 'to-love' } }

    its(:total_results) { is_expected.to eq(11) }
    its(:total_pages) { is_expected.to eq(6) }
    its(:start) { is_expected.to eq(5) }
    its(:page) { is_expected.to eq(3) }
    its(:items_per_page) { is_expected.to eq(2) }
    its(:first_page?) { is_expected.to eq(false) }
    its(:last_page?) { is_expected.to eq(false) }
    its(:prev_page) { is_expected.to eq(2) }
    its(:next_page) { is_expected.to eq(4) }

    context '#pagination_url_for' do
      it 'will be the URL without page # for :first' do
        expect(subject.pagination_url_for(:first)).to eq("http://test.host/catalog.json?somebody=to-love")
      end
      it 'will be the URL for :previous' do
        expect(subject.pagination_url_for(:previous)).to eq("http://test.host/catalog.json?page=2&somebody=to-love")
      end
      it 'will be the URL with the next page for :next' do
        expect(subject.pagination_url_for(:next)).to eq("http://test.host/catalog.json?page=4&somebody=to-love")
      end
      it 'will be the URL with the last page for :last' do
        expect(subject.pagination_url_for(:last)).to eq("http://test.host/catalog.json?page=6&somebody=to-love")
      end
    end
  end

  describe 'in case where no results were returned' do
    let(:response) do
      { 'response' => { 'docs' => [], 'numFound' => 0, 'start' => 0 }, 'responseHeader' => { 'params' => { 'rows' => 12 } } }
    end
    let(:query_parameters) { { 'somebody' => 'to-love' } }

    its(:total_results) { is_expected.to eq(0) }
    its(:total_pages) { is_expected.to eq(1) }
    its(:start) { is_expected.to eq(0) }
    its(:page) { is_expected.to eq(1) }
    its(:items_per_page) { is_expected.to eq(12) }
    its(:first_page?) { is_expected.to eq(true) }
    its(:last_page?) { is_expected.to eq(true) }
    its(:prev_page) { is_expected.to eq(nil) }
    its(:next_page) { is_expected.to eq(nil) }

    context '#pagination_url_for' do
      it 'will be the URL without page # for :first' do
        expect(subject.pagination_url_for(:first)).to eq("http://test.host/catalog.json?somebody=to-love")
      end
      it 'will be the URL for :previous' do
        expect(subject.pagination_url_for(:previous)).to eq(false)
      end
      it 'will be the URL with the next page for :next' do
        expect(subject.pagination_url_for(:next)).to eq(false)
      end
      it 'will be the URL with the last page for :last' do
        expect(subject.pagination_url_for(:last)).to eq("http://test.host/catalog.json?somebody=to-love")
      end
    end
  end

  describe 'in case results returned is smaller than page size' do
    let(:response) do
      { 'response' => { 'docs' => [], 'numFound' => 5, 'start' => 0 }, 'responseHeader' => { 'params' => { 'rows' => 12 } } }
    end
    let(:query_parameters) { { 'somebody' => 'to-love' } }

    its(:total_results) { is_expected.to eq(5) }
    its(:total_pages) { is_expected.to eq(1) }
    its(:start) { is_expected.to eq(0) }
    its(:page) { is_expected.to eq(1) }
    its(:items_per_page) { is_expected.to eq(12) }
    its(:first_page?) { is_expected.to eq(true) }
    its(:last_page?) { is_expected.to eq(true) }
    its(:prev_page) { is_expected.to eq(nil) }
    its(:next_page) { is_expected.to eq(nil) }

    context '#pagination_url_for' do
      it 'will be the URL without page # for :first' do
        expect(subject.pagination_url_for(:first)).to eq("http://test.host/catalog.json?somebody=to-love")
      end
      it 'will be the URL for :previous' do
        expect(subject.pagination_url_for(:previous)).to eq(false)
      end
      it 'will be the URL with the next page for :next' do
        expect(subject.pagination_url_for(:next)).to eq(false)
      end
      it 'will be the URL with the last page for :last' do
        expect(subject.pagination_url_for(:last)).to eq("http://test.host/catalog.json?somebody=to-love")
      end
    end
  end

  describe 'at the end of the pagination' do
    let(:response) do
      { 'response' => { 'docs' => [], 'numFound' => 11, 'start' => 11 }, 'responseHeader' => { 'params' => { 'rows' => 2 } } }
    end
    let(:query_parameters) { { 'page' => 6, 'somebody' => 'to-love' } }

    its(:total_results) { is_expected.to eq(11) }
    its(:total_pages) { is_expected.to eq(6) }
    its(:start) { is_expected.to eq(11) }
    its(:page) { is_expected.to eq(6) }
    its(:items_per_page) { is_expected.to eq(2) }
    its(:first_page?) { is_expected.to eq(false) }
    its(:last_page?) { is_expected.to eq(true) }
    its(:prev_page) { is_expected.to eq(5) }
    its(:next_page) { is_expected.to eq(nil) }

    context '#pagination_url_for' do
      it 'will be the URL without page # for :first' do
        expect(subject.pagination_url_for(:first)).to eq("http://test.host/catalog.json?somebody=to-love")
      end
      it 'will be the URL for :previous' do
        expect(subject.pagination_url_for(:previous)).to eq("http://test.host/catalog.json?page=5&somebody=to-love")
      end
      it 'will be false for :next' do
        expect(subject.pagination_url_for(:next)).to eq(false)
      end
      it 'will be the URL with the last page for :last' do
        expect(subject.pagination_url_for(:last)).to eq("http://test.host/catalog.json?page=6&somebody=to-love")
      end
    end
  end
end
