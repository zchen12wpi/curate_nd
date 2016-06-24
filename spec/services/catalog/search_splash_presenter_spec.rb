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

      context 'one top-level department' do
        let(:top_level_department_params) do
          {
            f: {
              described_class.department_key => ['University of Notre Dame']
            }
          }
        end
        subject { described_class.call(top_level_department_params) }
        it { is_expected.to eq('University of Notre Dame') }
      end

      context 'more than one department' do
      end

      context 'Articles' do
        let(:article_params) do
          {
            f: {
              described_class.category_key => ['Article']
            }
          }
        end
        subject { described_class.call(article_params) }
        it { is_expected.to eq(described_class::ARTICLE_SPLASH) }
      end

      context 'Datasets' do
        let(:dataset_params) do
          {
            f: {
              described_class.category_key => ['Dataset']
            }
          }
        end
        subject { described_class.call(dataset_params) }
        it { is_expected.to eq(described_class::DATASET_SPLASH) }
      end

      context 'Theses and Dissertations' do
        let(:etd_params) do
          {
            f_inclusive: {
              described_class.category_key => [
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
