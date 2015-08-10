#!/bin/bash

## Variables

# Nice looking name of service for script to report back to users
SERVERNAME="CraftBukkit"
# Filename of server binary
SERVICE="craftbukkit.jar"
# Path of server binary and world
MCPATH="/home/minecraft/server"
# mcrcon path
RCONPATH="/home/minecraft/mcrcon"
# mcrcon host
RCONHOST="localhost"
# mcrcon password
RCONPASSWD="thisisapassword"
# Where backups go
BACKUPPATH="/tmp/minecraft"
# Find the world name from the existing server file
WORLDNAME="$(cat $MCPATH/server.properties | grep -E 'level-name' | sed -e s/.*level-name=//)"

## Set the server read-only, save the map, and have Linux sync filesystem buffers to disk

mc_saveoff() {
	$RCONPATH -H $RCONHOST -p $RCONPASSWD "say SERVER BACKUP STARTING. Server going read-only..."
	$RCONPATH -H $RCONHOST -p $RCONPASSWD "dynmap pause all"
	$RCONPATH -H $RCONHOST -p $RCONPASSWD "save-off"
	$RCONPATH -H $RCONHOST -p $RCONPASSWD "save-all"
	sync
	sleep 10
}

## Set the server read-write

mc_saveon() {
	$RCONPATH -H $RCONHOST -p $RCONPASSWD "say SERVER BACKUP ENDED. Server going read-write..."
	$RCONPATH -H $RCONHOST -p $RCONPASSWD "dynmap pause none"
	$RCONPATH -H $RCONHOST -p $RCONPASSWD "save-on"
	$RCONPATH -H $RCONHOST -p $RCONPASSWD "dynmap pause none"
}

## Check and see if a worldname was given to the backup command. Use the default world, or check the optional world exists and exit if it doesn't.

mc_checkbackup() {
	if [ -n "$1" ]
	then
		WORLDNAME="$1"
		if [ -d "$MCPATH/$WORLDNAME" ]
		then
			echo " * Found world named \"$MCPATH/$WORLDNAME\""
		else
			echo " * Could not find world named \"$MCPATH/$WORLDNAME\""
        		exit 1
		fi
	fi
}

## Backs up map by rsyncing current world to backup location, creates tar.gz with datestamp

mc_backupmap() {
	pushd $MCPATH
	rsync -crLpoghu {$WORLDNAME,"${WORLDNAME}_nether","${WORLDNAME}_the_end",plugins,ops.json,server.properties,whitelist.json} $BACKUPPATH
	sleep 10
	NOW="$(date +%Y-%m-%d.%H-%M-%S)"
	# Create a compressed backup file and background it so we can get back to restarting the server
	popd
	pushd $BACKUPPATH
	tar -czf "${WORLDNAME}_backup_${NOW}.tar.gz" Blech Blech_nether Blech_the_end plugins ops.json server.properties whitelist.json
	mv "${WORLDNAME}_backup_${NOW}.tar.gz" /backup/minecraft
	rm -rf *
}

## Removes any backups older than 7 days, designed to be called by daily cron job

mc_removeoldbackups() {
	pushd /backup/minecraft
	find . -name "*${WORLDNAME}_backup*" -type f -mtime +7 | xargs rm -f
	find . -name "*${SERVICE}_backup*" -type f -mtime +190 | xargs rm -f
}

## Rotates logfile to server.1 through server.30, designed to be called by daily cron job

mc_logrotate() {
	# Server logfiles in chronological order
	LOGLIST=$(ls -r ${MCPATH}/server.log* | grep -v lck)
	# How many logs to keep
	COUNT="14"
	# Look at all the logfiles
	for logfile in $LOGLIST; do
		LOGTMP="$(basename $logfile | cut -d '.' -f 3)"
		# If we're working with server.log then append .1
		if [ -z "$LOGTMP" ]
		then
			LOGNEW="server.log.1"
			cp $logfile $MCPATH/$LOGNEW
			# Otherwise, check if the file number is greater than $COUNT
		elif [ "$LOGTMP" -gt "$COUNT" ]
		then
			# If so, delete it
			rm -f $logfile
		else
			# Otherwise, add one to the number
			LOGBASE="$(basename $logfile | cut -d '.' -f 1-2)"
			LOGNEW="$LOGBASE.$(($LOGTMP+1))"
			cp $logfile $MCPATH/$LOGNEW
		fi
	done
	# Blank the existing logfile to renew it
	echo -n \"\" > $MCPATH/server.log
}

## These are the parameters passed to the script

case "$1" in
	backup)
		mc_checkbackup "$2"
		mc_saveoff
		mc_backupmap
		mc_saveon
	;;
	removeoldbackups)
		mc_removeoldbackups
	;;
	logrotate)
		mc_logrotate
	;;
	*)
	echo " * Usage: minecraft {backup|removeoldbackups|logrotate}"
	exit 1
	;;
esac

exit 0

