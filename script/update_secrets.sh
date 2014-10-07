#!/bin/bash
#
# Copy the preproduction secrets to the correct place for deployment
#
# This runs on the worker VM and on the cluster
#
# usage:
#   ./update_secrets.sh <name of secret repo>

secret_repo=$1

if [ -d $secret_repo ]; then
    echo "=-=-=-=-=-=-=-= delete $secret_repo"
    rm -rf $secret_repo
fi
echo "=-=-=-=-=-=-=-= git clone $secret_repo"
git clone "git@git.library.nd.edu:$secret_repo"

files_to_copy="
    admin_api_keys.yml
    admin_usernames.yml
    application.yml
    database.yml
    doi.yml
    fedora.yml
    manager_usernames.yml
    noids.yml
    recipients_list.yml
    redis.yml
    service_dn.yml
    smtp_config.yml
    solr.yml
    work_type_permissions.yml
    licensing_permissions.yml
    newrelic.yml
    etd_manager_usernames.yml
    "

for f in $files_to_copy; do
    echo "=-=-=-=-=-=-=-= copy $f"
    if [ -f $secret_repo/curate_nd/$f ];
    then
        cp $secret_repo/curate_nd/$f config/$f
    else
        echo "Fatal Error: File $f does not exist in $secret_repo/curate_nd"
        exit 1
    fi
done
echo "=-=-=-=-=-=-=-= copy secret_token.rb"
cp $secret_repo/curate_nd/secret_token.rb config/initializers/secret_token.rb
