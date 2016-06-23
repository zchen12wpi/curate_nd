require 'fast_spec_helper'
require 'catalog/hierarchical_value_presenter'

module Catalog
  RSpec.describe HierarchicalValuePresenter do
    let(:hierarchical_value) { 'Level 1::Level 2' }

    describe '#call' do
      context 'without links' do
        subject do
          described_class.call(
            value: hierarchical_value,
            opener: '<div>',
            closer: '</div>'
          )
        end
        it { is_expected.to eq([
          "<div><span class=\"hierarchy\">Level 1</span><span class=\"hierarchy\">Level 2</span></div>"
        ]) }
      end

      context 'with links' do
        subject do
          described_class.call(
            value: hierarchical_value,
            opener: '<div>',
            closer: '</div>',
            link: true
          )
        end
        it do
          is_expected.to eq([
          "<div><span class=\"hierarchy\"><a href=\"/catalog?f%5Badmin_unit_hierarchy_sim%5D%5B%5D=Level+1\">Level 1</a></span><span class=\"hierarchy\"><a href=\"/catalog?f%5Badmin_unit_hierarchy_sim%5D%5B%5D=Level+1%3ALevel+2\">Level 2</a></span></div>"
          ])
        end
      end
    end

    describe '#decorate_with_links' do
      subject do
        described_class.decorate_with_links(
          value: hierarchical_value,
          opener: '<span>',
          closer: '</span>',
          path: '/search',
          param: 'f[name][]',
          param_delimiter: '|'
        )
      end
      it do
        is_expected.to eq(
          "<span><a href=\"/search?f%5Bname%5D%5B%5D=Level+1\">Level 1</a></span><span><a href=\"/search?f%5Bname%5D%5B%5D=Level+1%7CLevel+2\">Level 2</a></span>"
        )
      end
    end

    describe '#decorate' do
      subject do
        described_class.decorate(
          value: hierarchical_value,
          delimiter: '::',
          opener: '<span>',
          closer: '</span>'
        )
      end
      it { is_expected.to eq("<span>Level 1</span><span>Level 2</span>") }
    end
  end
end
