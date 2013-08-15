#!/bin/bash

# Starts the application server. It assumes
# there is an nginx reverse proxy at port 80

source /etc/profile.d/chruby.sh
chruby 1.9.3-p392

source /home/app/curatend/current/script/get-env.sh
cd $RAILS_ROOT
bundle exec unicorn -D -E deployment -c $RAILS_ROOT/config/unicorn.rb
