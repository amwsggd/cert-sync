#!/bin/bash

FILTER=''
CERTS_DIR=

chown -R root:root "$CERTS_DIR"
chmod -R 755 "$CERTS_DIR"
docker ps -q --filter "$FILTER" | xargs -r -I {} docker exec {} nginx -s reload

