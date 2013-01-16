#!/bin/bash

echo
echo "** Beginning the script $0"
echo

. "$(dirname "$0")"/../../lib/symlink.sh
local_etc="$(readlink_f "$(dirname "$0")/etc")"

symlink "..$local_etc" /etc
