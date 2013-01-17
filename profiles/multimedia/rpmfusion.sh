#!/bin/bash

while getopts "ksy" options
do
    case $options in
        s) SHORT="true" ;;
        ?) ;;
    esac
done

if [[ ! -z $SHORT ]]; then
    exit 0
fi

##############################################################################
# RPMFusion Repository

site="http://download1.rpmfusion.org"
if grep -q Rawhide /etc/redhat-release; then
    if ! rpm -q rpmfusion-free-release; then
        rpm -Uvh "$site/free/fedora/rpmfusion-free-release-rawhide.noarch.rpm"
    fi
    if ! rpm -q rpmfusion-nonfree-release; then
        rpm -Uvh "$site/nonfree/fedora/rpmfusion-nonfree-release-rawhide.noarch.rpm"
    fi
else
    if ! rpm -q rpmfusion-free-release; then
        rpm -Uvh "$site/free/fedora/rpmfusion-free-release-stable.noarch.rpm"
    fi
    if ! rpm -q rpmfusion-nonfree-release; then
        rpm -Uvh "$site/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm"
    fi
fi

