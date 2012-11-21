# setup-functions.sh
# Copyright 2008-2010 Andrew McNabb <amcnabb@mcnabbs.org>

# TODO: fix the following bug:
#   If there is an existing symlink at, say, /etc/init.d, then this function
#   will replace this symlink with a directory if etc/init.d is a directory
#   in the source location.

readlink -f / >/dev/null 2>/dev/null
if [[ $? = 0 ]]; then
    function readlink_f() {
        readlink -f "$1"
    }
else
    function readlink_f() {
        python -c "import os, sys; print(os.path.realpath(sys.argv[1]))" "$1"
    }
fi

# A fancy version of `ln -sf $1 $2`.  Note that it will recurse into
# subdirectories, but it will not link files starting with ".".
symlink() {
    local filepath="$1"
    local linkpath="$2"

    if [[ ${filepath:0:1} = "/" ]]; then
        local canonical_filepath="$filepath"
    else
        local canonical_filepath="$(readlink_f "$(dirname "$linkpath")/$filepath")"
    fi
    if [[ ! -e $canonical_filepath ]]; then
        echo "File $filepath does not exist (relative to $linkpath)."
        return 1
    fi

    if [[ -h $linkpath ]]; then
        rm -f "$linkpath"
    elif [[ -e $linkpath && ! (-d $canonical_filepath && -d $linkpath) ]]; then
        mv -bT "$linkpath" "$linkpath.old"
    fi

    if [[ -d $canonical_filepath ]]; then
        mkdir -p "$linkpath"
        for canonical_subfilepath in "$canonical_filepath"/*; do
            if [[ ! -e $canonical_subfilepath ]]; then
                # Bash is insane.  If $filepath is empty, then it will set
                # $subfilepath to "$filepath/*".  There's no file named "*".
                # Use zsh!
                break
            fi
            local subfilepath="$filepath/$(basename "$canonical_subfilepath")"
            local sublinkpath="$linkpath/$(basename "$subfilepath")"
            if [[ ${subfilepath:0:1} = "/" ]]; then
                symlink "$subfilepath" "$sublinkpath"
            else
                symlink "../$subfilepath" "$sublinkpath"
            fi
        done
    else
        ln -s "$filepath" "$linkpath"
    fi
}
