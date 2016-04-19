#!/usr/bin/env bash

# Create list of all objects from SOLR index, and place into a CSV file.
#
# Labels for the columns are in the first row of the CSV file. This creates a
# scratch directory named `results` to hold the temporary download files. The
# final CSV file has a name of the form `all-20160419.csv` where the number is
# the date the script was run.
#
# Set the environmental variable `SOLR_URL` to point to the solr index to query
#
# The query run depends on some curate specific metadata fields, including:
#
#  * pid
#  * Creation date
#  * Modification date
#  * Object State (Active or Inactive or Deleted) [this should always be "A"]
#  * Active Fedora Model
#  * "Has Model"
#  * Title
#  * Human readable type
#  * Depositor
#  * Read access group [i.e. public/registered or blank (== private)]
#
# Example usage:
#
#     ./make-csv-of-solr.sh
#
# OR
#
#     env SOLR_URL="https://solr41prod.example.com:8443/solr/curate" ./make-csv-of-solr.sh

if [ -z $SOLR_URL ]; then
   SOLR_URL="http://localhost:8983/solr/curate"
fi

mkdir results

for OFFSET in $(seq 0 1000 25000); do
    echo "Fetching 1000 from offset $OFFSET..."
    curl --silent "$SOLR_URL/select?q=*%3A*&start=$OFFSET&rows=1000&fl=id%2Csystem_create_dtsi%2Csystem_modified_dtsi%2Cobject_state_ssi%2Cactive_fedora_model_ssi%2Chas_model_ssim%2Cdesc_metadata__title_tesim%2Chuman_readable_type_tesim%2Cdepositor_tesim%2Cread_access_group_ssim&wt=csv" > results/$OFFSET.csv
done

TARGET="all-$(date '+%Y%m%d').csv"
first=1
for f in $(ls results/*.csv); do
    # only copy the labels on the first file
    if [[ $first == 1 ]]; then
        cat $f > $TARGET
        first=0
    else
        # don't copy the first line since it contains the column labels
        awk 'NR > 1 { print $0 }' < $f >> $TARGET
    fi
done
