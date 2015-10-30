require "jshintrb/jshinttask"

Jshintrb::JshintTask.new :jshint do |t|
  t.pattern = 'app/assets/**/*.js'
  t.options = :jshintrc
end
