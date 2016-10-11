Collecting CurateND stats
=========================

Most of our reporting is based on fiscal years, which begin in July.
Modify the dates in the following as appropriate.

# Total space used

 1. Log into fedoraprod
 1. Look in file `~dbrower/stats/20160630.csv`
 1. Look for line starting with "und" (should be last line in file), and use last number on line
for the total disk space used by fedora.

# Total number of items

 1. Log into the metrics database

        mysql metrics_prod -u metrics_prod_dba -h XXXX -p

 1. Run the query

        select count(*) from fedora_objects where obj_ingest_date < "2016-07-01" and resource_type not regexp '^(GenericFile|Hydramata_Group|LinkedResource|Person|Profile|ProfileSection)$';

# Number of items by access type

 1. Log into metrics database
 1. Run the following query

        select access_rights,count(*) from fedora_objects where obj_ingest_date < "2016-07-01" and resource_type not regexp '^(GenericFile|Hydramata_Group|LinkedResource|Person|Profile|ProfileSection)$' group by access_rights ;

# Pageviews

 1. Log into google analytics
 1. Enter date range into view (2015-07-01 through 2016-06-30)
 1. Look at "Pageviews" count

