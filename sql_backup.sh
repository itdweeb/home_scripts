#!/bin/bash

NOW="$(date +%Y-%m-%d.%H-%M-%S)"
mkdir -p /tmp/sql

pushd /tmp/sql
mysqldump MyMusic46 > MyMusic46.sql
mysqldump MyVideos78 > MyVideos78.sql
mysqldump ampache > ampache.sql
mysqldump --opt --events --ignore-table=mysql.events mysql > mysql.sql
mysqldump tt-rss > tt-rss.sql
mysqldump wordpress > wordpress.sql
popd

pushd /tmp
tar -pczf /backup/backup/sql/sql-"$NOW".tar.gz /tmp/sql
rm -rf /tmp/sql/*
popd

pushd /backup/backup/sql
find . -name "sql*" -type f -mtime +7 | xargs rm -f
popd
