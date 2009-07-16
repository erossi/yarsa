#!/bin/bash
#
# Mirror dir automatico per backup via rsyncd
#
# this release
VERSION="2.0-2"
PATH=/bin:/usr/bin:/sbin:/usr/sbin
DEBUG=1

# Number of days to keep
ROTATE_DIR=7

# Complete path to backup server
# in the form of
# server::modulo
BACKUP_FROM=$1

# Dir where to store the incremental backups
# es.
# /backup/myserver.com/
BACKUP_TO=$2

#RSYNC_SWITCH="-av --delete --whole-file --numeric-ids"
RSYNC_SWITCH="-av --delete --delete-excluded --ignore-errors --whole-file --numeric-ids"

# first log the status
echo "MY backup rel. $VERSION"
echo "-----------------------"
echo
echo "mirrordisk start at $(date)"
echo "From: $BACKUP_FROM"
echo "to: $BACKUP_TO"
echo

echo "-- df -m --"
df -m
echo

# Check the dest.
echo -n "Check dest. dir..........................["
if [ ! -d "$BACKUP_TO" ]
 then
 echo "FAILED]"
 exit 1
fi
echo "OK]"

# 1st erasing the oldest
echo -n "Removing $ROTATE_DIR ..............................["
if [ -d $BACKUP_TO/d$ROTATE_DIR ]
 then
 rm -rf $BACKUP_TO/d$ROTATE_DIR
 echo "OK]"
 else
 echo "FAILED]"
fi

# rotate

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

echo -n "Hard linking d1 to d0 ...................["
if [ -d $BACKUP_TO/d1 ]
 then
 cp -al $BACKUP_TO/d1 $BACKUP_TO/d0
 echo "OK]"
 else
 echo "FAILED]"
fi

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
