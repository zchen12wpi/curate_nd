#!/usr/bin/env bash

# Invoked by the CurateND-Integration Jenkins project
echo "=-=-=-=-=-=-=-= start $0 $1 $@"

target_env=$1
shift 1
capistrano_command=$@

if [ -z $target_env ]; then
    echo "=-=-=-=-=-=-=-= target_env parameter missing"
    echo "Exiting $0"
    exit 1
fi
echo "=-=-=-=-=-=-=-= environment: ${target_env}"

if [ -z "$capistrano_command" ]; then
    echo "=-=-=-=-=-=-=-= capistrano_command parameter missing"
    echo "Exiting $0"
    exit 1
fi

echo "=-=-=-=-=-=-=-= command: ${capistrano_command}"

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

echo "=-=-=-=-=-=-=-= cap ${target_env}_cluster ${capistrano_command}"
$WORKSPACE/vendor/bundle/bin/cap -v -f "$WORKSPACE/Capfile" ${target_env}_cluster $capistrano_command
retval=$?

echo "=-=-=-=-=-=-=-= do_deploy finished $retval"
exit $retval