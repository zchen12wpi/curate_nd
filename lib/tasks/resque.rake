require 'resque/pool/tasks'
# this task will get called before resque:pool:setup
# and preload the rails environment in the pool manager
task "resque:setup" => :environment do
  # generic worker setup, e.g. Hoptoad for failed jobs
end
puts "setting up resque pool"
task "resque:pool:setup" => :environment do
  ActiveRecord::Base.connection.disconnect!
  Resque::Pool.after_prefork do |job|
    ActiveRecord::Base.establish_connection
    Resque.redis.client.reconnect
  end
end
