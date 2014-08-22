namespace :curatend do
  desc 'Updates index - usage: rake curatend:update_solr_index FILE="/path/to/json/file/containing/pids.json"'
  task :update_solr_index => [:environment] do

    if ENV['FILE']
      data = File.read( ENV[ 'FILE' ] )
      json_object = JSON.parse(data)
      json_object.each do |pid|
        obj = ActiveFedora::Base.find( pid, cast: true )
        obj.update_index
      end
    end
  end
end
