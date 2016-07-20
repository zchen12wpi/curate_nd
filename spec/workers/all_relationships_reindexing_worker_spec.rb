require 'spec_helper'
require 'all_relationships_reindexing_worker.rb'

RSpec.describe AllRelationshipsReindexerWorker do
  let(:worker) { described_class.new }
  context '#run' do
    it 'will call the Curate::Indexer.reindex_all!' do
      expect(Curate::Indexer).to receive(:reindex_all!)
      worker.run
    end

    it 'will call Airbrake if an exception is encountered and re-raise the exception' do
      expect(Airbrake).to receive(:notify_or_ignore)
      expect(Curate::Indexer).to receive(:reindex_all!).and_raise(RuntimeError)
      expect { worker.run }.to raise_error(RuntimeError)
    end
  end
end
