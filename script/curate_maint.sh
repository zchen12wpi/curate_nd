#!/bin/bash

# script to activate/deactive CurateND Maintenance WebPage

export REPO_ROOT="/repo_data/fedora/curate_migration"

# print correct usage and exit

print_usage ()
{
	echo "usage: curate_maint.sh <action>"
	echo
	echo "	where <action> is one of the following:"
	echo "		on"
	echo "		off"
	exit 1
}

# 
chk_ret ()
{
        if [ $? -ne 0 ]
        then
                echo "Error $1 - Exiting"
                exit 1
        fi
}

if [ $# -ne 1 ]
then
	print_usage
fi

case $1 in
	on) touch /home/app/curatend/shared/system/maintenance;;
	off) rm -f /home/app/curatend/shared/system/maintenance;;
	  *) print_usage;;
esac

exit 0

