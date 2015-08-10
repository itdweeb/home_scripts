#!/bin/bash

NOW="$(date +%Y-%m-%d.%H-%M-%S)"
mkdir -p /tmp/cron
pushd /tmp/cron
crontab -l > root-crontab
crontab -u minecraft -l > minecraft-crontab
crontab -u www-data -l > www-data-crontab
popd

pushd /tmp
tar -pczf crontab-"$NOW".tar.gz /tmp/cron
cp crontab-"$NOW".tar.gz /backup/backup
rm -rf /tmp/sql/*

pushd /backup/backup
find . -name "crontab*" -type f -mtime +7 | xargs rm -f
popd
