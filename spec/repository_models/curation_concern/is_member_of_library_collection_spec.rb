require 'spec_helper'

module CurationConcern
  RSpec.describe IsMemberOfLibraryCollection do
    before do
      class Member < ActiveFedora::Base
        include CurationConcern::IsMemberOfLibraryCollection
      end
    end

    after do
      CurationConcern.send(:remove_const, :Member)
    end

    describe '#update_index' do
      it 'will call Curate.relationship_reindexer as part of the update_index' do
        work = Member.new(pid: '123')
        expect(Curate.relationship_reindexer).to receive(:call).with(work.pid).and_return(:called)
        expect(work.update_index).to eq(:called)
      end
    end
  end
end
