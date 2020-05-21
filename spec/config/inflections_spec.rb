require 'spec_helper'

describe 'inflections' do
  it 'plural of "thesis" is "theses"' do
    expect("thesis".pluralize).to eq('theses')
  end
  it 'singular of "theses" is "thesis"' do
    expect("theses".singularize).to eq('thesis')
  end

  it '"senior_thesis" should classify to SeniorThesis' do
    expect("senior_thesis".classify).to eq("SeniorThesis")
  end

  it '"senior_theses" should classify to SeniorThesis' do
    expect("senior_theses".classify).to eq("SeniorThesis")
  end
end
