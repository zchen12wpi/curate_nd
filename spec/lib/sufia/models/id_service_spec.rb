require 'spec_helper'

describe Sufia::IdService do
  # This test just makes sure the correct IdService is loaded
  # since the location of the file it patches moves around in sufia
  it "can get pids from a noids server" do
    VCR.use_cassette("id_service-1") do
      Sufia::IdService.configure(server: "localhost:13001", pool: "test")
      expect(Sufia::IdService.mint).to eq("und:071k")
      expect(Sufia::IdService.noid_template).to eq(".sdddk")
      expect(Sufia::IdService.valid?("070g")).to eq(true)
      expect(Sufia::IdService.valid?("und:070g")).to eq(true)
    end
  end

  it "falls back to local minter if no noids server configured" do
    allow(Sufia.config).to receive(:noid_template) { ".zdd" }
    allow(Sufia.config).to receive(:id_namespace) { "test" }
    Sufia::IdService.configure(nil)
    expect(Sufia::IdService.mint).to eq("test:00")
    expect(Sufia::IdService.noid_template).to eq(".zdd")
    expect(Sufia::IdService.valid?("70")).to eq(true)
  end

  after(:all) { Sufia::IdService.configure(nil) }
end
