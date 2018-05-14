
require 'spec_helper'
require 'group_editor_pids_worker.rb'

describe GroupEditorPIDsWorker do
  describe '#batch_assign_editor' do
    valid_pids = ["pid:1", "pid:2", "pid:3", "pid:123"]

    it 'Assign editor_pid to each pid' do
      group = FactoryGirl.create(:group)
      work = FactoryGirl.create(:generic_work)
      editor_pid = group.pid
      pids = [work.pid]
      worker = GroupEditorPIDsWorker.new(editor_pid,pids)
      worker.run
      work = work.class.find(work.pid)
      expect(work.edit_groups).to include(group.pid)
    end

    it 'Throws exception for Invalid editor_pid' do
      editor_pid = "zxw"
      pids = ["pid:1", "pid:2", "pid:3"]
      worker = GroupEditorPIDsWorker.new(editor_pid,pids)
      expect{worker.run}.to raise_error(ActiveFedora::ObjectNotFoundError)
    end

    it 'Throws exception for Invalid pid in pids list' do
      editor_pid = "pad:123"
      pids = ["pid:1", "pid:2", "pib"]
      worker = GroupEditorPIDsWorker.new(editor_pid,pids)
      expect{worker.run}.to raise_error(ActiveFedora::ObjectNotFoundError)
    end

    it 'Throws exception for Missing editor_pid' do
      editor_pid = ""
      pids = ["pid:1", "pid:2", "pid:3"]
      worker = GroupEditorPIDsWorker.new(editor_pid,pids)
      expect{worker.run}.to raise_error("EditorPID is required")
    end

    it 'Throws exception for Missing pids' do
      editor_pid = "pid:123"
      pids = []
      worker = GroupEditorPIDsWorker.new(editor_pid,pids)
      expect{worker.run}.to raise_error("PIDs is required")
    end

  end
end
