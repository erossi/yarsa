#!/bin/sh

PROG=/root/rsync_backup/mirror_rsync.sh
LOGDIR=/var/log

# example nfs1
RHOST=nfs1.adgb.net
RDIR=homes
NUMDAYS=7
LOG=$LOGDIR/bck-$RHOST-$RDIR.log
$PROG $RHOST::$RDIR /mnt/backup/$RHOST/$RDIR/ $NUMDAYS >$LOG 2>&1
#/usr/bin/mail user@host.com < $LOG
savelog -c $NUMDAYS $LOG >/dev/null 2>&1

