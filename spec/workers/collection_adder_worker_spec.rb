require 'spec_helper'

describe CollectionAdderWorker do
  let(:items) { [1,2,3,4].map { |i| FactoryGirl.create(:document) } }
  let(:item_pids) { items.map { |item| item.pid } }

  it 'adds each item in the pid list' do
    collection = FactoryGirl.create(:collection)
    worker = CollectionAdderWorker.new(collection.pid, item_pids)
    expect(collection.members).to eq([])
    worker.run
    collection = ActiveFedora::Base.find(collection.pid, cast: true)
    expect(collection.members).to match_array(items)
  end

  it 'errors if the collection cannot be found' do
    worker = CollectionAdderWorker.new("invalid_pid", item_pids)
    expect { worker.run }.to raise_error(ActiveFedora::ObjectNotFoundError)
  end

  it 'errors if the collection pid is not a collection' do
    worker = CollectionAdderWorker.new(item_pids.first, item_pids)
    expect { worker.run }.to raise_error(CollectionAdderWorker::Error)
  end
end
