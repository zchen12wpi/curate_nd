require 'spec_helper'

describe Admin::Reindex do
  let(:short_list) { ["pid:1", "pid:2", "pid:3", "pid:4"] }
  let(:long_list) { short_list * 7 }

  it 'puts short lists into a single batch' do
    expect(Sufia.queue).to receive("push")
    r = Admin::Reindex.new(short_list)
    r.add_to_work_queue
  end

  it 'puts long lists into many batches' do
    n = (long_list.length / 10.0).ceil
    expect(Sufia.queue).to receive("push").exactly(n).times
    r = Admin::Reindex.new(long_list)
    r.add_to_work_queue
  end
end
