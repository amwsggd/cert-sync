#!/bin/bash

FILTER=''
DIR=

chown -R root:root "$DIR"
chmod -R 755 "$DIR"
docker ps -q --filter "$FILTER" | xargs -r -I {} docker exec {} nginx -s reload

