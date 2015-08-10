#!/bin/bash

NOW="$(date +%Y-%m-%d.%H-%M-%S)"

pushd /var
tar -pczf /backup/backup/www-"$NOW".tar.gz /var/www
popd

pushd /backup/backup
find . -name "www*" -type f -mtime +7 | xargs rm -f
popd
