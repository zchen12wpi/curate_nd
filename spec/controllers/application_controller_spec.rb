require 'spec_helper'

describe ApplicationController do
  it 'has a helper method for #new_session_path' do
    expect(controller._helper_methods.include?(:new_session_path)).to be_truthy
  end
end
