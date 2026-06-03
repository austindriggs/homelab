#!/bin/bash

# Exit on error
set -e

# Variables
MOUNT_POINT="/mnt/tgroup"
SRC="/mnt/raid1/"
DST="$MOUNT_POINT/"

echo "!!! ONLY RUN THIS SCRIPT ON THE SERVER !!!"

# Ensure mount point is valid
if ! mountpoint -q "$MOUNT_POINT"; then
	echo "$MOUNT_POINT is not mounted."
	exit 1
fi

# rsync backup
rsync -av --info=progress2 --partial --update --delete \
    --exclude 'backup_zb.txt' \
    --exclude 'backup_zb.log' \
    --exclude 'Jellyfin/' \
    --exclude '.backup/' \
    "$SRC" "$DST" | tee -a "$MOUNT_POINT/backup_zb.log"

# Write updated timestamp
echo "Last updated on $(date +"%Y-%m-%d at %H:%M:%S")" > "$MOUNT_POINT/backup_zb.txt"
echo "ZimaBlade backup is complete."

# Unmount for safety
sudo umount "$MOUNT_POINT"
echo "$MOUNT_POINT is unmounted."
