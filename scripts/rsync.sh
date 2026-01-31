#!/usr/bin/env bash

# Helper script to rsync all important data from foxtrot.fmd-foss.org to a local diretory.
# For example, this is useful to create offline backups to a USB stick.
#
# Please only back up these files to LUKS-encrypted storage!
# https://www.kuketz-blog.de/dm-crypt-luks-daten-unter-linux-sicher-verschluesseln/

set -eux

OUTPUTDIR=${1-}

if [ -z "$OUTPUTDIR" ]; then
    echo "Error: missing output directory"
    echo "Usage: $0 <output-dir>"
    exit 1
fi

# This needs to run as "offlinebackup" on the remote host in order to be allowed to read the directories.
HOST="offlinebackup@foxtrot.fmd-foss.org"

rsync --archive --verbose --delete \
    "${HOST}:/packages" \
    "${HOST}:/prometheus" \
    "${HOST}:/var/lib/fmd-server-edge" \
    "${HOST}:/var/lib/fmd-server-prod" \
    "${HOST}:/var/lib/grafana" \
    "${OUTPUTDIR}" # destination
