#!/bin/bash
# bootstrap.sh
# Copyright 2008-2011 Andrew McNabb <amcnabb@mcnabbs.org>
#
# Set up an account on a Linux computer to have the exact same configuration
# as every other amcnabb account.  Unfortunately, there are a few manual
# steps, so here's the procedure:
#
# 1) copy bootstrap.sh (this script) to the target account
# 2) ensure that `git` is installed (or specify -p or -s)
# 3) run `bootstrap.sh` in the target account
# 4) install any programs that are reported as missing (or specify -s)
# 5) ensure that the login manager can use .xsession as a session; in Fedora
#    this requires the `xorg-x11-xinit-session` package
# 6) it is also recommended to change the user shell to `/bin/zsh` (or use -s)

##############################################################################
# Script Configuration (feel free to edit these)

# Where the per-user working tree of configuration files will be stored.
HOME_CONFIG_DIR="$HOME/config"

# Where a bare repository will be stored (if the -w option is not specified).
# If you _never_ want a bare repository, set this to be an empty string.  If
# you ever use a system-wide repository, it will be important to have this.
BARE_REPO="$HOME/git/config.git"

# Where the system-wide working tree will be stored (with the -s option).
SYS_CONFIG_DIR="/config"

# The bare repository where the system-wide working tree will share changes.
# This should usually be the full path to your personal bare repository.
SYS_BARE_REPO="/home/amcnabb/git/config.git"

# The list of all upstream repositories.  It is a list of the form:
#   ( name1 url1 name2 url2 name3 url3 )
# Note that we will clone from the first repository in this list, so it can't
# be empty.
CONFIG_REMOTES=( mcnabbs amcnabb@mcnabbs.org:git/config.git
    mcbain amcnabb@mcbain.mcnabbs.org:git/config.git
    mcbain2 amcnabb@a.mcnabbs.org:git/config.git
    aml amcnabb@aml.cs.byu.edu:git/config.git
    byucs amcnabb@iocane.cs.byu.edu:git/config.git
    )

##############################################################################
# Command-line Processing, etc.

# Die if any individual command fails.
set -e

USAGE="Usage: $0 [OPTIONS]

Options:
  -h   Help message.
  -s   System postinstall: makes a system-wide /config and runs sysconfig.sh.
       Requires root access.  Works best if the -b option is also specified.
  -b   Use a local bare repo.  If not doing a system postinstall (-s option),
       then actually create the local bare repo, too.
"

SYSTEM_POSTINSTALL=""
USE_LOCAL_BARE=""
WORKING_TREE_ONLY=""
while getopts "hsb" options
do
    case $options in
        s) SYSTEM_POSTINSTALL="true" ;;
        b) USE_LOCAL_BARE="true" ;;
        *) echo "$USAGE" ; exit -1 ;;
    esac
done

if [[ $(id -un) == "root" && ! $SYSTEM_POSTINSTALL ]]; then
    echo "Refusing to run as root.  If you want to do a system postinstall,"
    echo "then specify the -s option."
    exit -1
fi

##############################################################################
# Make sure Git is installed

if [[ ! -x /usr/bin/git ]]; then
    if [[ -x /bin/rpm ]]; then
        echo "Installing git with yum."
        sudo /usr/bin/yum -y install git
        if [[ $? -ne 0 ]]; then
            echo "Could not install git with yum."
            exit -1
        fi
    elif [[ -x /usr/bin/dpkg ]]; then
        echo "Installing git with apt-get."
        sudo /usr/bin/apt-get update && sudo /usr/bin/apt-get install git-core
        if [[ $? -ne 0 ]]; then
            echo "Could not install git with apt-get."
            exit -1
        fi
    else
        echo "Warning: cannot find rpm or dpkg; can't install git!"
        exit -1
    fi
fi

##############################################################################
# System Postinstall, Part 1

if [[ $SYSTEM_POSTINSTALL ]]; then
    echo
    echo "We need to set the hostname of the current machine.  Please specify"
    echo "the fully qualified domain name (e.g., "scorpio.mcnabbs.org")."
    echo -n "Fully qualified domain name: "
    read HOSTNAME
fi

##############################################################################
# Setup config repository

if [[ $SYSTEM_POSTINSTALL ]]; then
    config_dir="$SYS_CONFIG_DIR"
else
    config_dir="$HOME_CONFIG_DIR"
fi

# Ensure that there is a non-bare clone at $config_dir.
if ! git --git-dir="$config_dir/.git" rev-parse 2>/dev/null; then
    # Move any existing $config_dir out of the way.
    if [[ -e $config_dir ]]
    then
        mv -b -T "$config_dir" "$config_dir.old"
    fi
    # Clone the main remote repository to $config_dir.
    git clone "${CONFIG_REMOTES[1]}" "$config_dir"
fi

if [[ $USE_LOCAL_BARE && $SYSTEM_POSTINSTALL ]]; then
    # Point origin at $SYS_BARE_REPO.  Note: this is bad if the user doesn't
    # have a user private group and root tries to push.  Right now I don't
    # have a good workaround.  Just use user private groups.
    git --git-dir "$config_dir/.git" config remote.origin.url "$SYS_BARE_REPO"
elif [[ $USE_LOCAL_BARE ]]; then
    # Ensure that there is a bare clone at $BARE_REPO
    if ! git --git-dir "$BARE_REPO" rev-parse 2>/dev/null
    then
        # Move any existing $BARE_REPO out of the way.
        if [[ -e $BARE_REPO ]]; then
            mv -b -T "$BARE_REPO" "$BARE_REPO.old"
        fi

        if [[ `id -un` = `id -gn` ]]; then
            mkdir -p "$BARE_REPO"
            git --bare --git-dir "$BARE_REPO" init --shared=group
            git --git-dir "$BARE_REPO" fetch "$HOME_CONFIG_DIR" master:master
        else
            git clone --bare "$HOME_CONFIG_DIR" "$BARE_REPO"
        fi
    fi

    # Point origin at $BARE_REPO.
    git --git-dir "$config_dir/.git" config remote.origin.url "$BARE_REPO"
fi

# Setup remote branches
pushd "$config_dir"
for (( key = 0; $key < "${#CONFIG_REMOTES[@]}" ; key += 2 ))
do
    value=$(( $key + 1 ))
    git remote add "${CONFIG_REMOTES[$key]}" "${CONFIG_REMOTES[$value]}" || true
done
popd


##############################################################################
# Confirm that essential packages are installed, etc.

if [[ $SYSTEM_POSTINSTALL ]]; then
    echo "Starting postinstall script."
    "$SYS_CONFIG_DIR/bin/sysconfig.sh" -n "$HOSTNAME"
else
    "$HOME_CONFIG_DIR/bin/homeconfig.sh"
fi

# vim: et sts=4 sw=4
