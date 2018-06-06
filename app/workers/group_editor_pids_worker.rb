class GroupEditorPIDsWorker

  attr_reader :pids, :editor_pid

# JSON input file is expected to have the following format:
# {
#   "EditorPID": "editor_pid"
#   "WorkPIDs": ["list", "of", "pids"]
# }
# After JSON received, set array of pids editor needs applied to
# loop through pids, add editor_pid to pids

  def initialize(editor_pid, pids)
    @editor_pid = editor_pid
    @pids = Array.wrap(pids)
  end

  def run
    check_pids
    batch_assign_editor
  end

  private

  def check_pids
    raise "EditorPID is required" if editor_pid.empty?
    raise "WorkPIDs is required" if pids.empty?
  end

  def batch_assign_editor
    editor_group = Hydramata::Group.find(editor_pid)
    @pids.each do |pid|
      work = ActiveFedora::Base.find(pid, cast: true)
      work.add_record_editor_group(editor_group)
    end
  end

end
