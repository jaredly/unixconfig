
##########################
#### All of the aliai ####
##########################

alias lsd='ls -ld *(-/DN)'
alias lsa='ls -ld .*'

alias gits="git status"
alias gitsn="git status|grep 'Changed but not updated:' -A 1000|grep 'modified:\|deleted:'"
alias gitn="git status|grep 'Untracked files:' -A 1000|grep ^#$'\t'|sed -e 's/^#\t//'"
alias gitca="git commit -am"
alias gitc="git commit -m"
alias gitd='git diff'

alias g=git
alias ga="git commit -a"
alias gaam="git commit -a --amend"
alias gad="git add"
alias gam="git commit --amend"
alias gb="git branch"
alias gc="git commit"
alias gca="git commit -a"
alias gco="git checkout"
alias gd="git diff"
alias gm="git commit -m"
alias gmt="git mergetool"
alias gpnp='git pull && git push'
alias gs="git status"
alias gsu="git submodule update --init --recursive"
alias gt="git t"
alias gta="git ta"
alias gtr="git tree"

alias hs='hg st'
alias hc='hg commit -m'
alias hd='hg diff'
alias hp='hg pull -u'
alias ll="ls -l"
alias la="ls -la"

alias nv="nvim"
alias vim="nvim"

alias m='make'
alias mkae=make

alias j='jshint --verbose'
alias jl='j lib *.js'
alias ja='j . lib test'

alias ip=ipython
alias vs='vim --servername'

alias vkhan=". ~/.virtualenv/khan27/bin/activate"

alias mba='mocha --compilers "js:babel/register"'

#####################
#### PATH THINGS ####
#####################

export PYTHONPATH=$PYTHONPATH:~/python
export GOPATH="/home/jared/go"
export JAVA_HOME=/usr/lib/jvm/java

export PATH=~/bin:~/.local/bin:$PATH
export PATH=$PATH:./vendor/bin
export PATH=$PATH:$HOME/.rvm/bin:$HOME/.cabal/bin # Add RVM to PATH for scripting
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin:/home/jared/go/bin"
export PATH=$PATH:$GOPATH/bin

##############################
#### Platform Differences ####
##############################

if [[ `uname` == 'Darwin' ]]; then
    alias ls='ls -GF'
    export JAVA_HOME=`/usr/libexec/java_home`
    export CPPFLAGS=-Qunused-arguments
    export CFLAGS=-Qunused-arguments
    export PATH=$PATH:$HOME/khan/devtools/arcanist/khan-bin
    . ~/.virtualenv/khan27/bin/activate
else
    alias open='google-chrome'
    alias ls='ls --color=auto -F'
    alias e=vim
fi

if [[ `hostname` =~ ".*aml.*" ]]; then
    alias vim=vimx
fi

#######################
#### Custom things ####
#######################

# always run ls after cd
function chpwd() {
    emulate -L zsh
    ls -a
}

export ALTERNATE_EDITOR=''
export DEFAULT_USER="jared"


autoload -U compinit
compinit

export PS1="${WINDOW}:%~$ "
export EDITOR=vim

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[OA" up-line-or-beginning-search # Up
bindkey "^[OB" down-line-or-beginning-search # Down
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey "${terminfo[kpp]}" up-line-or-search
bindkey "${terminfo[kpp]}" up-line-or-search
bindkey "${terminfo[knp]}" down-line-or-search
bindkey "${terminfo[knp]}" down-line-or-search

bindkey -v
bindkey ^r history-incremental-search-backward

### Awesome history
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=10000
SAVEHIST=10000

# Show history
case $HIST_STAMPS in
    "mm/dd/yyyy") alias history='fc -fl 1' ;;
    "dd.mm.yyyy") alias history='fc -El 1' ;;
    "yyyy-mm-dd") alias history='fc -il 1' ;;
    *) alias history='fc -l 1' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data
setopt hist_ignore_all_dups

#### More 

preexec () {
    if [[ $WINDOW != "" ]];then
        echo -ne "\ek${PWD/*\//}\e\\"
    fi
}

[[ -s ~/.nvm/nvm.sh ]] && . ~/.nvm/nvm.sh 2>&/dev/null
. /Users/jared/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export PATH="/Users/jared/.multirust/bin:$PATH"


# The next line updates PATH for the Google Cloud SDK.
source '/Users/jared/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/jared/google-cloud-sdk/completion.zsh.inc'

# eval $(docker-machine env default)
