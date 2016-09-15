require 'spec_helper'

RSpec.describe OsfIngestWorker do
  let(:attributes) { { project_identifier: 'pi1', administrative_unit: 'au1', owner: 'o1', affiliation: 'a1' } }
  let(:archive) { Admin::IngestOSFArchive.new(attributes) }
  let(:queue) { [] }
  context '.create_osf_job' do
    it 'will enqueue the given archive as a primative and reify' do
      expect(queue).to receive(:push).with(kind_of(described_class)).and_call_original
      expect(described_class).to receive(:new).with(attributes).and_call_original
      described_class.create_osf_job(archive, queue: queue)
      expect(queue.map(&:attributes)).to eq([attributes])
    end
  end
  context '.default_queue' do
    subject { described_class.default_queue }
    it { is_expected.to respond_to(:push) }
    it { is_expected.to eq(Sufia.queue) }
  end

  context '#attributes' do
    subject { described_class.new(attributes).attributes }
    it { is_expected.to eq(attributes) }
  end

  context '#run' do
    subject { described_class.new(attributes) }

    it 'will start an osf archive ingest via the BatchIngestor' do
      expect(BatchIngestor).to receive(:start_osf_archive_ingest).with(attributes)
      subject.run
    end

    it 'will notify airbrake if an exception is encountered' do
      exception = RuntimeError.new('OUCH!')
      allow(BatchIngestor).to receive(:start_osf_archive_ingest).and_raise(exception)
      expect(Airbrake).to receive(:notify_or_ignore).with(
        error_class: exception.class, error_message: exception, parameters: { OsfIngestWorker_attributes: attributes }
      )
      expect { subject.run }.to raise_error(exception)
    end
  end
end
