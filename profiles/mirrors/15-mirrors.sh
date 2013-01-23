#!/bin/bash

# Setup the fstab entry for mirrors.
if ! grep -q MIRRORS /etc/fstab
then
    echo "LABEL=MIRRORS /mnt/mirrors ext4 noauto 0 0" >>/etc/fstab
fi
mkdir -p /mnt/mirrors
