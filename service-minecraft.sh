#!/bin/bash

RCONPATH="/home/minecraft/mcrcon"
RCONHOST="localhost"
RCONPASSWD="thisisapassword"

$RCONPATH -H $RCONHOST -p $RCONPASSWD "say SERVER BEING PATCHED! SERVER GOING OFFLINE IN 5 MINUTES!"

sleep 5m

$RCONPATH -H $RCONHOST -p $RCONPASSWD "say SERVER MAINTENANCE STARTING. Server going read-only..."
$RCONPATH -H $RCONHOST -p $RCONPASSWD "dynmap pause all"
$RCONPATH -H $RCONHOST -p $RCONPASSWD "save-off"
$RCONPATH -H $RCONHOST -p $RCONPASSWD "save-all"
$RCONPATH -H $RCONHOST -p $RCONPASSWD "stop"
sleep 1m
$RCONPATH -H $RCONHOST -p $RCONPASSWD "say SERVER in READ-ONLY. Shutting down now. Will return in 20 minutes."

sudo systemctl stop minecraft
sleep 19m
sudo systemctl start minecraft
