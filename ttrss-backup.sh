#!/bin/bash

URL="https://loserdude.crabdance.com/tt-rss/opml.php?op=publish&key=n8lruu53f6ab7c0490f"

curl -0 -k $URL > /backup/backup/RSS/`date +"ttrss-%Y-%m-%d.%H-%M-%S.opml"`

pushd /backup/backup/RSS
find . -name "ttrss*" -type f -mtime +15 | xargs rm -f
popd

