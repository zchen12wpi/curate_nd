require 'spec_helper'
require "#{Rails.root}/lib/curate/build_identifier"

describe Curate::BuildIdentifier do

  let(:expected_current_id) { "#{current_year}.26" }
  let(:expected_next_id) { "#{current_year}.27" }

  let(:current_year) { DateTime.now.strftime("%Y") }
  let(:previous_year) { (current_year.to_i - 1).to_s }
  let(:file_path){ Rails.root.join("spec", "build-identifier_spec.txt") }

  describe "current_id" do
    it "should return the default build id when file not found" do
      File.stub(:read).with(file_path).and_raise
      Curate::BuildIdentifier.current_id(file_path).should == "#{current_year}.0"
    end

    it "should return the current build id" do
      File.stub(:read).with(file_path) { "#{current_year}.26" }
      Curate::BuildIdentifier.current_id(file_path).should == expected_current_id
    end
  end

  describe "next_id" do
    it "should return the next build id" do
      Curate::BuildIdentifier.stub(:extract_build_info).and_return( [current_year, '26'] )

      Curate::BuildIdentifier.next_id.should == expected_next_id
    end
  end

  describe "generate_next_build_id" do
    it "should write the next_build_id to the file" do
      File.exists?(file_path).should == false

      Curate::BuildIdentifier.generate_next_build_id(file_path)

      File.exists?(file_path).should == true
      File.read(file_path).strip.should == "#{current_year}.1"
    end

    it "should read the existing build_id file, increment the build_id part and write it to the file" do
      File.open(file_path, 'w+') do |file|
        file.puts "#{current_year}.73"
      end

      Curate::BuildIdentifier.generate_next_build_id(file_path)

      File.read(file_path).strip.should == "#{current_year}.74"
    end

    it "should reset the build id to 1 if year changes" do
      File.open(file_path, 'w+') do |file|
        file.puts "#{previous_year}.73"
      end

      Curate::BuildIdentifier.generate_next_build_id(file_path)

      File.read(file_path).strip.should == "#{current_year}.1"
    end
  end

  after(:each) do
    if File.exist?(file_path)
      File.delete(file_path)
    end
  end
end
