require 'fast_spec_helper'
require 'bendo/datastream_presenter'

module Bendo
  RSpec.describe DatastreamPresenter do
    let(:service_url) { 'http://bendo.io/' }
    let(:bendo_url) { 'http://bendo.io/item/01234' }
    let(:invalid_bendo_url) { 'https://archive.org'}
    let(:mock_datastream) do
      Struct.new(:location)
    end
    let(:datastream) do
      mock = mock_datastream.new
      mock.location = bendo_url
      mock
    end
    let(:datastream_with_invalid_url) do
      mock = mock_datastream.new
      mock.location = invalid_bendo_url
      mock
    end
    let(:invalid_datastream) do
      Struct.new(:blank).new
    end
    let(:instance) do
      described_class.new(
        datastream: datastream,
        service_url: service_url
      )
    end

    describe '#valid?' do
      # Is a redirect datastream & a Bendo URL
      # Is a redirect datastream & NOT a Bendo URL
      # Is NOT a redirect datastream & a Bendo URL
      # Is NOT a redirect datastream & NOT a Bendo URL
    end

    describe '#location' do
      context 'datastream responds to `:location`' do
        subject { instance.location }
        it { is_expected.to eq(bendo_url) }
      end

      context 'datastream does NOT respond to `:location`' do
        subject { described_class.new(datastream: invalid_datastream).location }
        it { is_expected.to be_nil }
      end
    end

    describe 'item_path' do
      # :location is a valid URI with a :path
      # :location is a valid URI WITHOUT a :path
      # :location is NOT a valid URI
    end
  end
end
