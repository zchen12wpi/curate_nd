require 'downloads_controller'
ActivityEngine.register('DownloadsController', 'show') do |activity,context|
  activity.subject = context.generic_file
  activity.current_user = context.current_user
  activity.activity_type = 'downloads#show'
end

require 'curation_concern/senior_theses_controller'
['create', 'update'].each do |action_name|
  ActivityEngine.register('CurationConcern::SeniorThesesController', action_name) do |activity,context|
    activity.subject = context.curation_concern
    activity.current_user = context.current_user
    activity.activity_type = "curation_concern/senior_theses##{action_name}"
  end
end

require 'curation_concern/generic_files_controller'
['rollback', 'update'].each do |action_name|
  ActivityEngine.register('CurationConcern::GenericFilesController', action_name) do |activity,context|
    activity.subject = context.generic_file
    activity.current_user = context.current_user
    activity.activity_type = "curation_concern/senior_theses##{action_name}"
  end
end
