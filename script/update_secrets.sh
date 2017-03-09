#!/bin/bash
#
# Copy the preproduction secrets to the correct place for deployment
#
# This runs on the worker VM and on the cluster
#
# usage:
#   ./update_secrets.sh <secret_dir> 

secret_dir=$1

files_to_copy="
    admin_api_keys.yml
    admin_usernames.yml
    application.yml
    bendo.yml
    database.yml
    fedora.yml
    manager_usernames.yml
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
    if [ -f $secret_dir/$f ];
    then
        cp $secret_dir/$f config/$f
    else
        echo "Fatal Error: File $f does not exist in $secret_dir"
        exit 1
    fi
done
echo "=-=-=-=-=-=-=-= copy secret_token.rb"
cp $secret_dir/secret_token.rb config/initializers/secret_token.rb
