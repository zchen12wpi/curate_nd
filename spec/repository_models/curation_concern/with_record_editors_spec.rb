require 'spec_helper'
require 'active_fedora/test_support'

describe CurationConcern::WithRecordEditors do

  describe 'add_record_editor_group' do
    it "raise error for wrong parameter" do
      user = FactoryGirl.create(:user)
      work = FactoryGirl.create(:generic_work)
      expect{work.add_record_editor_group(user)}.to raise_error
    end

    it "will be part of the edit group and not the read group" do
      group = FactoryGirl.create(:group)
      work = FactoryGirl.create(:generic_work)
      work.add_record_editor_group(group)
      expect(work.edit_groups).to include(group.pid)

      expect(work.read_groups).not_to include(group.pid)

# => expect(group.works).to include(work) does not pass for unknown reason?
# => shows as an Array in debug
      expect(group.works.to_a).to include(work)
    end
  end

  describe 'remove_record_editor_group' do
    it "will be removed from the edit group" do
      group = FactoryGirl.create(:group)
      work = FactoryGirl.create(:generic_work)
      work.add_record_editor_group(group)
      work.remove_record_editor_group(group)
      expect(work.edit_groups).not_to include(group.pid)
    end
  end
end

describe CurationConcern::WithRecordViewers do

  describe 'add_record_viewer_group' do
    it "raise error for wrong parameter" do
      user = FactoryGirl.create(:user)
      work = FactoryGirl.create(:generic_work)
      expect{work.add_record_viewer_group(user)}.to raise_error
    end

    it "will be part of the read group and not the edit group" do
      group = FactoryGirl.create(:group)
      work = FactoryGirl.create(:generic_work)
      work.add_record_viewer_group(group)
      expect(work.edit_groups).not_to include(group.pid)

      expect(work.read_groups).to include(group.pid)

      # => expect(group.view_works).to include(work) does not pass for unknown reason?
      # => shows as an Array in debug
      expect(group.view_works.to_a).to include(work)
    end
  end

  describe 'remove_record_editor_group' do
    it "will be removed from the edit group" do
      group = FactoryGirl.create(:group)
      work = FactoryGirl.create(:generic_work)
      work.add_record_viewer_group(group)
      work.remove_record_viewer_group(group)
      expect(work.read_groups).not_to include(group.pid)
    end
  end
end
