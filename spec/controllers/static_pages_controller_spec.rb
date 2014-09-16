require 'spec_helper'

describe StaticPagesController do

  context 'GET #error.html' do
    it 'should respond with correct status code' do
      get 'error' , status_code: '555'
      expect(response.status).to eq(555)
      expect(assigns(:help_request)).to be_an_instance_of(HelpRequest)
      expect(response).to render_template('error')
    end
    it 'should respond with 500 status code when no status code present' do
      get 'error'
      expect(response.status).to eq(500)
      expect(response).to render_template('error')
    end
  end


end
