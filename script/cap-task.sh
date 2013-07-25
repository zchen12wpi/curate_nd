#!/usr/bin/env bash

# Invoked by the CurateND-Integration Jenkins project
#
echo "=-=-=-=-=-=-=-= start $0 $1 $2"

local target_env=$1
local capistrano_command=$2

if [ -z $target_env ]; then
    echo "=-=-=-=-=-=-=-= target_env parameter missing"
    echo "Exiting do_deploy"
    return 1
fi
echo "=-=-=-=-=-=-=-= environment $target_env"

if [ -z $capistrano_command ]; then
    echo "=-=-=-=-=-=-=-= capistrano_command parameter missing"
    echo "Exiting do_deploy"
    return 1
fi

LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
export PATH=/shared/git/bin:$PATH
export PATH=/global/soft/fits/current:/shared/fedora_prod36/java/bin:$PATH
export RAILS_ENV=$target_env

# fetch capistrano
echo "=-=-=-=-=-=-=-= bundle install"
/shared/ruby_prod/ruby/1.9.3/bin/bundle install --path="$WORKSPACE/vendor/bundle" --binstubs="$WORKSPACE/vendor/bundle/bin" --shebang '/shared/ruby_prod/ruby/1.9.3/bin/ruby' --deployment --without development test assets default headless --gemfile="$WORKSPACE/Gemfile"

echo "=-=-=-=-=-=-=-= cd $WORKSPACE"
cd $WORKSPACE

# echo "=-=-=-=-=-=-=-= cap ${target_env} deploy"
# $WORKSPACE/vendor/bundle/bin/cap -v -f "$WORKSPACE/Capfile" ${target_env}_cluster deploy
# retval=$?
