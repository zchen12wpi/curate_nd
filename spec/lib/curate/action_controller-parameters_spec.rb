require 'spec_helper'

describe ActionController::Parameters do
  subject { ActionController::Parameters.new }
  it 'is a Hash' do
    # @note This is important for the behavior of ./app/services/catalog/collection_decorator.rb
    expect(subject).to be_a(Hash)
  end
end
