#!/bin/bash

NOW="$(date +%Y-%m-%d.%H-%M-%S)"

tar -czf /backup/backup/usenet-"$NOW".tar.gz /home/download/sickbeard /home/download/couchpotato /home/download/.sabnzbd /etc/default/couchpotato /etc/default/sabnzbdplus /etc/default/sickbeard

pushd /backup/backup
find . -name "usenet*" -type f -mtime +7 | xargs rm -f
popd
