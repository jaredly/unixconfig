#!/bin/bash
# Make filesystem with:
#   mkfs.ext4 -i 65536 -m 0 -L MIRRORS /dev/sdX1
#   tune2fs -c 0 /dev/sdX1

# Fail on undefined variables.
set -u

# Fail on failure
set -e

mountpoint="/mnt/mirrors"
device="LABEL=MIRRORS"

echo "Mounting"
mkdir -p "$mountpoint"
mount "$device" "$mountpoint"

rsync -vaH --partial --filter=". mirror-fedora.txt" \
    --numeric-ids --delete --delete-after --delete-excluded \
    --prune-empty-dirs \
    rsync://mirrors.cs.byu.edu/fedora/ "$mountpoint/fedora"

echo "Unmounting"
umount "$mountpoint" || echo "Couldn't unmount."
