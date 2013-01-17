#!/bin/bash

##############################################################################
# Set the time zone to mountain time (Denver)

# For Fedora <18:
sed -i 's/^\(ZONE=\).*$/\1"America\/Denver"/' /etc/sysconfig/clock
cp /usr/share/zoneinfo/America/Denver /etc/localtime
# For Fedora 18:
timedatectl set-timezone America/Denver
