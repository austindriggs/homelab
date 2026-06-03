#!/bin/bash
set -e

MOUNT_POINT="/mnt/vulcan"
SRC="/mnt/raid1/Jellyfin/"
DST="$MOUNT_POINT/Jellyfin/"

# Mount USB drive manually
echo "Mounting /dev/sdc1..."
sudo mount -t ext4 /dev/sdc1 "$MOUNT_POINT"

# Verify mount
if ! mountpoint -q "$MOUNT_POINT"; then
    echo "Error: $MOUNT_POINT is not mounted."
    exit 1
fi

# rsync backup
rsync -av --info=progress2 --partial --update --delete \
    --exclude 'backup_jf.txt' \
    --exclude 'backup_jf.log' \
    --exclude 'Shows/' \
    "$SRC" "$DST" | tee -a "$MOUNT_POINT/backup_jf.log"

# Write updated timestamp + skipped shows
{
    echo "Last updated on $(date +"%Y-%m-%d at %H:%M:%S")"
    echo
    echo "Skipped shows directory:"
    tree "$SRC/Shows"
} > "$MOUNT_POINT/backup_jf.txt"

echo "Backup complete."

# Unmount for safety
echo "Unmounting..."
sudo umount "$MOUNT_POINT"
echo "Unmounted."
