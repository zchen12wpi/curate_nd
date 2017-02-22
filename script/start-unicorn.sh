#!/bin/bash

# Starts the application server. It assumes
# there is an nginx reverse proxy at port 80

export PATH=/opt/ruby/current/bin:$PATH

source /home/app/curatend/current/script/get-env.sh
cd $RAILS_ROOT
# This looks to be a bit of a misnomer; The script that is being run is wrongly
# interpretting
bundle exec unicorn -D -E $RAILS_ENV -c $RAILS_ROOT/config/unicorn.rb
