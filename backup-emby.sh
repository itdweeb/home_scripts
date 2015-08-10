#!/bin/bash

NOW="$(date +%Y-%m-%d.%H-%M-%S)"

pushd /var/lib/emby-server
tar -czf /backup/backup/emby-"$NOW".tar.gz ./config ./plugins ./data/collections ./data/playlists ./data/displaypreferences.db ./data/userdata_v2.db ./data/users.db
popd

pushd /backup/backup
find . -name "emby*" -type f -mtime +7 | xargs rm -f
popd
