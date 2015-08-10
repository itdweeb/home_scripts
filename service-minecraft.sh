#!/bin/bash

RCONPATH="/home/minecraft/mcrcon"
RCONHOST="localhost"
RCONPASSWD="thisisapassword"

$RCONPATH -H $RCONHOST -p $RCONPASSWD "say SERVER BEING PATCHED! SERVER GOING OFFLINE IN 5 MINUTES!"

sleep 5m

systemctl stop minecraft
sleep 15m
systemctl start minecraft
