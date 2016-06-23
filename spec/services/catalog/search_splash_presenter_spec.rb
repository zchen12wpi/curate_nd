require 'fast_spec_helper'
require 'catalog/search_splash_presenter'

module Catalog
  RSpec.describe SearchSplashPresenter do
    describe '.call' do
      context 'empty params' do
        let(:empty_params) { Hash.new }
        subject { described_class.call(empty_params) }
        it { is_expected.to eq(nil) }
      end

      context 'Articles' do
        let(:article_params) { { f: { human_readable_type_sim: ['Article'] } } }
        subject { described_class.call(article_params) }
        it { is_expected.to eq(described_class::ARTICLE_SPLASH) }
      end

      context 'Datasets' do
        let(:dataset_params) { { f: { human_readable_type_sim: ['Dataset'] } } }
        subject { described_class.call(dataset_params) }
        it { is_expected.to eq(described_class::DATASET_SPLASH) }
      end

      context 'Theses and Dissertations' do
        let(:etd_params) do
          {
            f_inclusive: {
              human_readable_type_sim: [
                'Doctoral Dissertation',
                "Master's Thesis"
              ]
            }
          }
        end
        subject { described_class.call(etd_params) }
        it { is_expected.to eq(described_class::ETD_SPLASH) }
      end
    end
  end
end
