#!/bin/sh

# Change to the path of the installation.
PROG=/root/rsync_backup/mirror_rsync.sh
LOGDIR=/var/log

# example backup the server myserver.fakedomain
RHOST=myserver.fakedomain
# The remote directory
RDIR=homes
# The number of backups to keep
NUMDAYS=7
# Log filename
LOG=$LOGDIR/bck-$RHOST-$RDIR.log

# Run the backup
$PROG $RHOST::$RDIR /mnt/backup/$RHOST/$RDIR/ $NUMDAYS >$LOG 2>&1

# If you want to receive the log file via email uncomment below.
#/usr/bin/mail user@host.com < $LOG

# Rotate the log files
savelog -c $NUMDAYS $LOG >/dev/null 2>&1
