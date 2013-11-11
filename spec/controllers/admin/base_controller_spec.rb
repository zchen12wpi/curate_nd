require 'spec_helper'

describe Admin::BaseController do
  it 'renders an index page' do
    get :index
    expect(response.status).to eq(200)
  end
end