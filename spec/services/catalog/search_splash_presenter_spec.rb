require 'fast_spec_helper'
require 'rspec/its'
require 'catalog/search_splash_presenter'

module Catalog
  RSpec.describe SearchSplashPresenter do
    describe '.call' do
      context 'empty params' do
        let(:empty_params) { Hash.new }
        subject { described_class.call(empty_params) }
        its(:title) { is_expected.to eq(nil) }
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
        its(:title) { is_expected.to eq('University of Notre Dame') }
      end

      context 'one nested department' do
        let(:nested_department_params) do
          {
            f: {
              described_class.department_key => [
                'University of Notre Dame:College of Arts and Letters'
              ]
            }
          }
        end
        subject { described_class.call(nested_department_params) }
        its(:title) { is_expected.to eq('College of Arts and Letters') }
      end

      context 'department with special naming needs' do
        let(:term) { 'University of Notre Dame:Hesburgh Libraries:General' }
        let(:nested_department_params) do
          {
            f: {
              described_class.department_key => [
                term
              ]
            }
          }
        end
        subject { described_class.call(nested_department_params) }
        its(:title) { is_expected.to eq(HierarchicalTermLabel::SimpleMapper::DEPARTMENT_LABEL_MAP.fetch(term)) }
      end

      context 'more than one department' do
        let(:multiple_department_params) do
          {
            f: {
              described_class.department_key => [
                'University of Notre Dame',
                'University of Notre Dame:College of Arts and Letters'
              ]
            }
          }
        end
        subject { described_class.call(multiple_department_params) }
        its(:title) { is_expected.to be_nil }
      end

      context 'Collections' do
        context 'one collection' do
          let(:single_collection_params) do
            {
              f: {
                described_class.collection_key => ['und:1234']
              }
            }
          end
          subject do
            described_class.call(single_collection_params, collection_decorator: described_class::TitleDecorator)
          end
          its(:title) { is_expected.to eq('und:1234') }
        end

        context 'more than one collection' do
          let(:multiple_collection_params) do
            {
              f: {
                described_class.collection_key => [
                  'und:1234',
                  'und:5678'
                ]
              }
            }
          end
          subject do
            described_class.call(multiple_collection_params, collection_decorator: described_class::TitleDecorator)
          end
          its(:title) { is_expected.to be_nil }
        end
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
        its(:title) { is_expected.to eq(described_class::ARTICLE_SPLASH) }
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
        its(:title) { is_expected.to eq(described_class::DATASET_SPLASH) }
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
        its(:title) { is_expected.to eq(described_class::ETD_SPLASH) }
      end

      context 'empty, but present' do
        context 'facet param' do
          context 'string' do
            let(:empty_facet_params) do
              {
                f: {
                  described_class.department_key => ''
                }
              }
            end
            subject { described_class.call(empty_facet_params) }
            its(:title) { is_expected.to be_nil }
          end

          context 'array' do
            let(:empty_facet_params) do
              {
                f: {
                  described_class.department_key => []
                }
              }
            end
            subject { described_class.call(empty_facet_params) }
            its(:title) { is_expected.to be_nil }
          end

          context 'array with blank value' do
            let(:empty_facet_params) do
              {
                f: {
                  described_class.department_key => ['']
                }
              }
            end
            subject { described_class.call(empty_facet_params) }
            its(:title) { is_expected.to be_nil }
          end
        end

        context 'inclusive facet param' do
          context 'string' do
            let(:empty_inclusive_facet_params) do
              {
                f_inclusive: {
                  described_class.department_key => ''
                }
              }
            end
            subject { described_class.call(empty_inclusive_facet_params) }
            its(:title) { is_expected.to be_nil }
          end

          context 'empty array' do
            let(:empty_inclusive_facet_params) do
              {
                f_inclusive: {
                  described_class.department_key => []
                }
              }
            end
            subject { described_class.call(empty_inclusive_facet_params) }
            its(:title) { is_expected.to be_nil }
          end

          context 'array with blank value' do
            let(:empty_inclusive_facet_params) do
              {
                f_inclusive: {
                  described_class.department_key => ['']
                }
              }
            end
            subject { described_class.call(empty_inclusive_facet_params) }
            its(:title) { is_expected.to be_nil }
          end
        end
      end
    end
  end
end
