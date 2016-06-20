require 'fast_spec_helper'
require 'bendo/datastream_presenter'

module Bendo
  RSpec.describe DatastreamPresenter do
    let(:service_url) { 'http://bendo.io/' }
    let(:bendo_url) { 'http://bendo.io/item/01234' }
    let(:non_bendo_url) { 'https://archive.org'}
    let(:mock_datastream) do
      Struct.new(:location, :controlGroup)
    end

    let(:bendo_datastream) do
      mock = mock_datastream.new
      mock.location = bendo_url
      mock.controlGroup = 'R'
      mock
    end

    let(:invalid_datastream) do
      Struct.new(:blank).new
    end

    let(:instance) do
      described_class.new(
        datastream: bendo_datastream,
        service_url: service_url
      )
    end

    describe '#valid?' do
      let(:bendo_datastream_without_redirect) do
        mock = mock_datastream.new
        mock.location = bendo_url
        mock
      end

      let(:non_bendo_datastream_without_redirect) do
        mock = mock_datastream.new
        mock.location = non_bendo_url
        mock
      end

      let(:non_bendo_datastream) do
        mock = non_bendo_datastream_without_redirect
        mock.controlGroup = 'R'
        mock
      end

      context 'redirect datastream with a Bendo URL'do
        subject { instance.valid? }
        it { is_expected.to be_truthy }
      end

      context 'redirect datastream with a non-Bendo URL'do
        subject do
          described_class.new(
            datastream: non_bendo_datastream,
            service_url: service_url
          ).valid?
        end
        it { is_expected.to be_falsey }
      end

      context 'non-redirect datastream with a Bendo URL' do
        subject do
          described_class.new(
            datastream: bendo_datastream_without_redirect,
            service_url: service_url
          ).valid?
        end
        it { is_expected.to be_falsey }
      end

      context 'non-redirect datastream with a non-Bendo URL' do
        subject do
          described_class.new(
            datastream: non_bendo_datastream_without_redirect,
            service_url: service_url
          ).valid?
        end
        it { is_expected.to be_falsey }
      end
    end

    describe '#location' do
      context 'datastream responds to `:location`' do
        subject { instance.location }
        it { is_expected.to eq(bendo_url) }
      end

      context 'datastream does NOT respond to `:location`' do
        subject do
          described_class.new(
            datastream: invalid_datastream,
            service_url: service_url
          ).location
        end
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
