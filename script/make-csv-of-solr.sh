#!/usr/bin/env bash

# Create list of all objects from SOLR index, and place into CSV files.
#
# Labels for the columns are in the first row of the CSV file. A scratch directory named `results` is
# created to hold the temporary download files. The generated CSV files have names in the following
# forms where the number is the date the script was run.
#
#  * `all-20160419.csv`
#  * `curate-20160419.csv`
#  * `curate-non-etd-20160419.csv`
#
# The first CSV file contains a list of every object in SOLR.
#
# The second CSV file contains a list of items which are CurateND specific. It
# filters on those items whose id starts with `und:`. This file exists to work
# around a bug which indexes _everything_ in fedora into solr, even items with
# different namespaces.
#
# The third CSV file contains a list of all non-ETDs Works in CurateND. It is a
# little hackish, and may miss something. (suggestions on a better way to do
# this are welcome).
#
# Set the environmental variable `SOLR_URL` to point to the solr index to query
# Set the environmental variable `PID_NAMESPACE` to change the namespace
# filtered out in the second file.
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
#     env PID_NAMESPACE="temp:" ./make-csv-of-solr.sh
#
# OR
#
#     env SOLR_URL="https://solr41prod.example.com:8443/solr/curate" ./make-csv-of-solr.sh

if [ -z $SOLR_URL ]; then
   SOLR_URL="http://localhost:8983/solr/curate"
fi

if [ -Z $PID_NAMESPACE ]; then
    PID_NAMESPACE="und:"
fi

mkdir results

for OFFSET in $(seq 0 1000 25000); do
    echo "Fetching 1000 at offset $OFFSET..."
    curl --silent "$SOLR_URL/select?q=*%3A*&start=$OFFSET&rows=1000&fl=id%2Csystem_create_dtsi%2Csystem_modified_dtsi%2Cobject_state_ssi%2Cactive_fedora_model_ssi%2Chuman_readable_type_tesim%2Cdepositor_tesim%2Cread_access_group_ssim%2Cdesc_metadata__title_tesim%2Cdesc_metadata__creator_tesim&wt=csv" > results/$OFFSET.csv
done

TARGET_ALL="all-$(date '+%Y%m%d').csv"
TARGET_CURATE="curate-$(date '+%Y%m%d').csv"
TARGET_NON_ETD="curate-non-etd-$(date '+%Y%m%d').csv"
first=1
for f in $(ls results/*.csv); do
    # only copy the labels on the first file
    if [[ $first == 1 ]]; then
        cat $f > $TARGET_ALL
        first=0
    else
        # don't copy the first line since it contains the column labels
        awk 'NR > 1 { print $0 }' < $f >> $TARGET_ALL
    fi
done

awk "/^(id|$PID_NAMESPACE)/ { print \$0 }" < $TARGET_ALL > $TARGET_CURATE

awk -F ',' '$6 ~ /human_readable_type_tesim|Article|Book|Collection|Dataset|Document|Finding Aid|Image|Manuscript|Presentation|Report|Senior Thesis|Software|Video/ {print $0}' < $TARGET_CURATE > $TARGET_NON_ETD

