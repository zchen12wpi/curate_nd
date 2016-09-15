require 'spec_helper'

RSpec.describe OsfIngestWorker do
  let(:attributes) { { project_identifier: 'pi1', administrative_unit: 'au1', owner: 'o1', affiliation: 'a1' } }
  let(:archive) { Admin::IngestOSFArchive.new(attributes) }
  let(:queue) { [] }
  context '.create_osf_job' do
    it 'will enqueue the given archive as a primative and reify' do
      expect(described_class).to receive(:new).and_call_original
      described_class.create_osf_job(archive, queue: queue)
    end
  end
  context '.default_queue' do
    subject { described_class.default_queue }
    it { is_expected.to respond_to(:push) }
    it { is_expected.to eq(Sufia.queue) }
  end

  context '#archive' do
    subject { described_class.new(attributes).archive }
    it { is_expected.to eq(archive) }
  end

  context '#run' do
    subject { described_class.new(attributes) }

    it 'will start an osf archive ingest via the BatchIngestor' do
      expect(BatchIngestor).to receive(:start_osf_archive_ingest).with(attributes)
      subject.run
    end
  end
end
