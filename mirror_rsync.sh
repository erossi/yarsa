#!/bin/bash
#
# backup via rsyncd
#
# this release
# todo: link to the git describe --tags
VERSION="3.0"
PATH=/bin:/usr/bin:/sbin:/usr/sbin
DEBUG=1

# todo: Check 3 param in input

# Complete path to backup server in the form of
# server::modulo
BACKUP_FROM=$1

# Dir where to store the incremental backups
# ex. /backup/myserver.com/
BACKUP_TO=$2

# Number of days to keep
ROTATE_DIR=$3

RSYNC_SWITCH="-av --delete --delete-excluded --ignore-errors --whole-file --numeric-ids"

# Find the oldest copy to remove
OLDEST_DIR=$(find $BACKUP_TO -maxdepth 1 -type d -name "rsb_*"|sort|head -1)

# todo: Check for /etc/mirror_rsync/mirror_rsync.conf

# todo: Check for ~/.mirror_rsync/mirror_rsync.conf

# first log the status
echo "Rsync backup v.$VERSION"
echo "-----------------------"
echo
echo "backup start at $(date)"
echo "From: $BACKUP_FROM"
echo "to: $BACKUP_TO"
echo

echo "-- df -m --"
df -m
echo

# Check the dest. dir
echo -n "Check dest. dir..........................["
if [ ! -d "$BACKUP_TO" ]
 then
 echo "FAILED]"
 exit 1
fi
echo "OK]"

# 1st erasing the oldest dir
echo -n "Removing $ROTATE_DIR ..............................["
if [ -d $BACKUP_TO/d$ROTATE_DIR ]
 then
 rm -rf $BACKUP_TO/d$ROTATE_DIR
 echo "OK]"
 else
 echo "FAILED]"
fi

# rotate all the other dir
for (( i=$ROTATE_DIR; i>0; i-- ))
 do
 (( j=i-1 ))
 echo -n "Moving d$j -> d$i .........................["
 if [ -d $BACKUP_TO/d$j ]
  then
  mv $BACKUP_TO/d$j $BACKUP_TO/d$i
  echo "OK]"
 else
  echo "FAILED]"
 fi
 done

# hard link the first one
echo -n "Hard linking d1 to d0 ...................["
if [ -d $BACKUP_TO/d1 ]
 then
 cp -al $BACKUP_TO/d1 $BACKUP_TO/d0
 echo "OK]"
 else
 echo "FAILED]"
fi

# and execute the sync
echo
echo ""
echo "rsync $RSYNC_SWITCH $BACKUP_FROM $BACKUP_TO/d0/ 2>&1"
echo
rsync $RSYNC_SWITCH $BACKUP_FROM $BACKUP_TO/d0/ 2>&1
echo
echo Completed

echo
echo "-- df -m --"
df -m
echo

echo "mirrordisk end at $(date)"

exit 0

