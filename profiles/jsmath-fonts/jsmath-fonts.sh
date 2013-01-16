#!/bin/bash

echo
echo "** Beginning the script $0"
echo

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
# Install Fonts for jsMath
if [[ -d /usr/share/fonts/Tex-fonts-20 ]]; then
    (cd /tmp
        wget http://www.math.union.edu/~dpvc/jsMath/download/TeX-fonts-20.zip
        cd /usr/share/fonts
        unzip /tmp/TeX-fonts-20.zip
        fc-cache -fv)
fi

