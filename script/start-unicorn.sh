#!/bin/bash

# Starts the application server. It assumes
# there is an nginx reverse proxy at port 80

export PATH=/opt/ruby/current/bin:$PATH

source /home/app/curatend/current/script/get-env.sh
cd /home/app/curatend/current/unicorn
BUNDLE_GEMFILE=./Gemfile_unicorn bundle exec unicorn -D -E $RAILS_ENV -c $RAILS_ROOT/unicorn/config/unicorn.rb
