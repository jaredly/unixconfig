#!/bin/bash
# Enable and disable specific services.

. "$(dirname $0)"/../../lib/symlink.sh

enable_service() {
    /sbin/chkconfig $1 on
    /sbin/service $1 restart
}

disable_service() {
    /sbin/chkconfig $1 off
    /sbin/service $1 stop
}

enable_service xinetd
enable_service nginx

