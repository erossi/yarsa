#!/bin/bash
#
# rsyncd backup
# Copyright (C) 2009-2013 Enrico Rossi
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

# this release
# todo: link to the git describe --tags
VERSION="3.0"
PATH=/bin:/usr/bin:/sbin:/usr/sbin
DEBUG=1

# todo: Check 3 params in input

# Complete path to backup server in the form of
# server::modulo
BACKUP_FROM=$1

# Dir where to store the incremental backups
# ex. /backup/myserver.com/
BACKUP_TO=$2

# Number of days to keep
ROTATE_DIR=$3

# The rsync command to use.
RSYNC_SWITCH="-av --delete --delete-excluded --ignore-errors --whole-file --numeric-ids"

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

# Check the destination directory for safe
echo -n "Check dest. dir..........................["

if [ ! -d "$BACKUP_TO" ]; then
    echo "FAILED]"
    exit 1
else
    echo "OK]"
fi

# 1st erasing the oldest dir
echo -n "Removing $ROTATE_DIR ..............................["

if [ -d $BACKUP_TO/d$ROTATE_DIR ]; then
    rm -rf $BACKUP_TO/d$ROTATE_DIR
    echo "OK]"
else
    echo "FAILED]"
    exit 2
fi

# rotate all the other dir
for (( i=$ROTATE_DIR; i>0; i-- )); do
    (( j=i-1 ))
    echo -n "Moving d$j -> d$i .........................["

    if [ -d $BACKUP_TO/d$j ]; then
        mv $BACKUP_TO/d$j $BACKUP_TO/d$i
        echo "OK]"
    else
        echo "FAILED]"
        exit 3
    fi
done

# hard link the first one
echo -n "Hard linking d1 to d0 ...................["

if [ -d $BACKUP_TO/d1 ]; then
    cp -al $BACKUP_TO/d1 $BACKUP_TO/d0
    echo "OK]"
else
    echo "FAILED]"
    exit 4
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
echo "rsync backup end at $(date)"
exit 0

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
