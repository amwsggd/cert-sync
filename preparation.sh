#!/usr/bin/env bash
set -euo pipefail

ORIGINAL_DIR=$(pwd)
SHELL_SCRIPT_DIR=$(dirname "$0")
cd "$SHELL_SCRIPT_DIR" || exit 1

SRC_DIR="../"
mapfile -t REMOTE_HOSTS_DIR < <(grep -vE '^[[:space:]]*($|#)' ./preparation-remote-hosts-dir.txt)
EXCLUDE_FILE="./exclude-file.txt"
USE_EXCLUDE_FILE="${1:-}"
RSYNC_ARGS=()
if [[ "$USE_EXCLUDE_FILE" == "exclude" ]]; then
	RSYNC_ARGS+=("--exclude-from=$EXCLUDE_FILE")
fi

for hostDir in "${REMOTE_HOSTS_DIR[@]}"; do
        host=$(echo "$hostDir" | cut -d":" -f1)
        innerHostDir=$(echo "$hostDir" | cut -d":" -f2)

        ssh "$host" "mkdir -p ${innerHostDir}.new"
        rsync -av --delete "${RSYNC_ARGS[@]}" "$SRC_DIR" "${hostDir}"

        ssh "$host" "
                set -e
                sudo chown -R root:root '${innerHostDir}.new'
                sudo chmod 755 '${innerHostDir}.new'
        "

done
