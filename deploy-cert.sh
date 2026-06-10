#!/usr/bin/env bash
set -euo pipefail

ORIGINAL_DIR=$(pwd)
SHELL_SCRIPT_DIR=$(dirname "$0")
cd "$SHELL_SCRIPT_DIR" || exit 1

source .env
mapfile -t REMOTE_HOSTS_DIR < <(grep -vE '^[[:space:]]*($|#)' ./remote-hosts-dir.txt)
EXCLUDE_FILE="./exclude-file.txt"

sudo ./deploy-locally.sh

for hostDir in "${REMOTE_HOSTS_DIR[@]}"; do
	host=$(echo "$hostDir" | cut -d":" -f1)
	innerHostDir=$(echo "$hostDir" | cut -d":" -f2)

	# directly sync the cert file
	rsync -av --delete \
	       --exclude-from="$EXCLUDE_FILE" \
       	       "$CERT_DIR/fullchain.pem" "${hostDir}/fullchain.pem.new"

	rsync -av --delete \
	       --exclude-from="$EXCLUDE_FILE" \
       	       "$CERT_DIR/private.pem" "${hostDir}/private.pem.new"

	ssh "$host" "
                set -e
                sudo chown -R root:root '${innerHostDir}'
                sudo chmod 755 '${innerHostDir}'

		mv ${innerHostDir}/private.pem.new ${innerHostDir}/private.pem
		mv ${innerHostDir}/fullchain.pem.new ${innerHostDir}/fullchain.pem
                $innerHostDir/../../shes/deploy-locally.sh
        "

done

cd $ORIGINAL_DIR
