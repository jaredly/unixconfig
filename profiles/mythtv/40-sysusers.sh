#!/bin/bash
# Create users and groups for MythTV.
# We pick an arbitrary but fixed user id and group id so that these are
# persistent between installs.

# MythTV backend user
getent group mythtv || groupadd -g 3999 mythtv
getent passwd mythtv || useradd -u 3999 -g mythtv -d /var/lib/mythtv \
    -s /bin/nologin -c "MythTV Backend User" mythtv
# This should happen in the mythtv RPM preinstall script, but do it here
# just in case.
usermod -a -G audio,video mythtv
