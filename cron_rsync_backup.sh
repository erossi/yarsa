#!/bin/sh
#
# rsync backup cron-exe example file
# Copyright (C) 2013 Enrico Rossi
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

# Change to the path of the installation.
PROG=/root/rsync_backup/rsync_backup
LOGDIR=/var/log

# example backup the server myserver.fakedomain module homes
# handled by rsyncd
SOURCE="myserver.fakedomain::homes"

# example destination dir.
DEST="/mnt/backup/myserver.fakedomain/homes"

# The number of backups to keep
BACKUPS=7

# Log filename
LOG=$LOGDIR/bck-$SOURCE.log

# Run the backup
$PROG $SOURCE $DEST $BACKUPS >$LOG 2>&1

# If you want to receive the log file via email uncomment below.
#/usr/bin/mail user@host.com < $LOG

# Rotate the log files
savelog -c $BACKUPS $LOG >/dev/null 2>&1

## Other backups

# example backup from a filesystem
SOURCE="/srv/somethingtobackup"
DEST="/mnt/backup/somethingtobackup"
BACKUPS=10
LOG=$LOGDIR/bck-$SOURCE.log
$PROG $SOURCE $DEST $BACKUPS >$LOG 2>&1
#/usr/bin/mail user@host.com < $LOG
savelog -c $BACKUPS $LOG >/dev/null 2>&1
