# setup-functions.sh
# Copyright 2008-2010 Andrew McNabb <amcnabb@mcnabbs.org>

# Creates a user or changes their uid.
create_user()
{
    uid=$( id -u "$1" )
    if [[ $uid != $2 ]]
    then
        if [[ $uid ]]
        then
            echo "Switching uid of user '$1'."
            /usr/sbin/usermod -c "$3" -u "$2" "$1"
            #userdel -f "$1"
        else
            echo "Creating user '$1' with id '$2'."
            /usr/sbin/useradd -c "$3" -u "$2" "$1"
        fi
    fi
}

# Creates a group or changes its gid.
create_group()
{
    name="$1"
    gid="$2"
    /usr/sbin/groupadd -g "$gid" "$name" || /usr/sbin/groupmod -g "$gid" "$name"
}

