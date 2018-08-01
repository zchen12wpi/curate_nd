if Rails.env.development?
  require 'byebug/core'
  #Byebug.wait_connection = true
  port = ENV.fetch("BYEBUG_SERVER_PORT", 9876).to_i
  print "Starting byebug server for remote debugging on port #{port}\n"
  Byebug.start_server 'localhost', port
end
