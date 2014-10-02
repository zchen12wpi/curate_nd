require 'spec_helper'
require 'json'

describe Admin::ReindexController do
  it 'accepts a JSON array' do
    data = ['pid:1', 'pid:2', 'pid:3', 'pid:4']
    reindexer = double
    expect(reindexer).to receive("add_to_work_queue")
    expect(Admin::Reindex).to receive('new').with(data).and_return(reindexer)
    post :reindex, data.to_json
    expect(response.status).to eq(200)
  end

  it 'returns a 400 on bad input' do
    data = "not json data"
    post :reindex, data
    expect(response.status).to eq(400)
  end

  it 'returns a 400 on json hashes' do
    data = { a: "hash" }
    post :reindex, data.to_json
    expect(response.status).to eq(400)
  end
end
