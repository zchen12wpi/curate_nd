#!/bin/bash
#
# Copy the preproduction secrets to the correct place for deployment
#
# This runs on the worker VM and on the server
#
# usage:
#   ./update_secrets.sh

# A prior build step for this environment should have build the confit files for this env,
# and copied them to /home/app/curatend/shared/config on the target machine

shared_config_dir=/home/app/curatend/shared/secrets

files_to_copy="
    admin_api_keys.yml
    admin_usernames.yml
    application.yml
    bendo.yml
    database.yml
    fedora.yml
    redis.yml
    smtp_config.yml
    solr.yml
    work_type_policy_rules.yml
    licensing_permissions.yml
    newrelic.yml
    etd_manager_usernames.yml
    "

for f in $files_to_copy; do
    echo "=-=-=-=-=-=-=-= copy $f"
    if [ -f $shared_config_dir/$f ];
    then
        cp $shared_config_dir/$f config/$f
    else
        echo "Fatal Error: File $f does not exist in $shared_config_dir"
        exit 1
    fi
done
echo "=-=-=-=-=-=-=-= copy secret_token.rb"
cp $shared_config_dir/secret_token.rb config/initializers/secret_token.rb
