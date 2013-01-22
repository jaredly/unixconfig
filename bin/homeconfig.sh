#!/bin/bash
# homeconfig.sh
# Copyright 2008-2010 Andrew McNabb <amcnabb@mcnabbs.org>

# Configures my home directory by making symlinks and checking whether
# programs are installed.

# Make sure the ssh config file is chmodded 644 to make ssh happy.
chmod -R g-w "$HOME/config"

# Create symlinks

. "$HOME/config/lib/symlink.sh" 
echo
echo "Bin Directory"
symlink config/bin "$HOME/bin"

echo "Dotfiles Directory"
for ref in "$HOME/config"/dotfiles/*
do
    path="$HOME/.$(basename $ref)"
    echo "Creating link $path => $ref"
    # replace a leading "$HOME/" with ""
    symlink "${ref#$HOME/}" "$path"
done
