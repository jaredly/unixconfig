#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

export ZSH_THEME=lukerandall
# export ZSH=~/.oh-my-zsh

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

export PS1="${WINDOW}:%~$ "
export EDITOR=vim

export DEFAULT_USER="jared"
## source ~/config/lib/agnoster.zsh-theme


## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors
#

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


preexec () {
    if [[ $WINDOW != "" ]];then
        echo -ne "\ek${PWD/*\//}\e\\"
    fi
}

if [[ `uname` == 'Darwin' ]]; then
    alias ls='ls -GF'
else
    alias open='google-chrome'
    alias ls='ls --color=auto -F'
fi
alias lsd='ls -ld *(-/DN)'
alias lsa='ls -ld .*'

bindkey -v

export PATH=~/bin:~/.local/bin:$PATH
export PYTHONPATH=$PYTHONPATH:~/python

bindkey ^r history-incremental-search-backward
setopt hist_ignore_all_dups

alias gits="git status"
alias gitsn="git status|grep 'Changed but not updated:' -A 1000|grep 'modified:\|deleted:'"
alias gitn="git status|grep 'Untracked files:' -A 1000|grep ^#$'\t'|sed -e 's/^#\t//'"
alias gitca="git commit -am"
alias gitc="git commit -m"
alias gitd='git diff'

alias gc="git commit"
alias gca="git commit -a"
alias ga="git commit -a"
alias gam="git commit --amend"
alias gaam="git commit -a --amend"
alias gad="git add"
alias gd="git diff"
alias gs="git status"
alias gco="git checkout"
alias g=git
alias gpnp='git pull && git push'

alias hs='hg st'
alias hc='hg commit -m'
alias hd='hg diff'
alias hp='hg pull -u'
alias ll="ls -l"

_make_pbj() {                     
    local a
    read -l a
    reply=(`./make.pbj --list "$a"`)
}
compctl -K _make_pbj ./make.pbj
alias pbj="./make.pbj"
export PATH="/usr/local/heroku/bin:$PATH"
export GOPATH="~/go"
export PATH="$PATH:/usr/local/go/bin:/home/jared/go/bin"
export PATH=$PATH:$GOPATH/bin
export JAVA_HOME=/usr/lib/jvm/java

# export VIRTUAL_ENV_DISABLE_PROMPT=1
export ALTERNATE_EDITOR=''

if [[ `uname` == 'Linux' ]]; then
    alias emacs='emacsclient -n'
    alias e=vim
fi

if [[ `hostname` =~ ".*aml.*" ]]; then
    alias vim=vimx
fi

if [[ `hostname` == 'jaredmac' ]]; then # all my settings for the familysearch mac
    export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
    alias fs='foreman start'
    ### Added by the Heroku Toolbelt
    export PATH="/usr/local/heroku/bin:$PATH"
    export PATH=$PATH:/Users/jared/pear/bin/

    alias emacs="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n"
    alias vi=emacs
    alias e=vim
    alias jenkins='java -jar ~/bin/jenkins-cli.jar -s http://ec2-174-129-97-38.compute-1.amazonaws.com:8080/'
    alias sauce='java -jar ~/Downloads/Sauce-Connect-latest/Sauce-Connect.jar jabapyth d99b97a7-abce-4d5a-bdf2-0581775bcdfe'
fi

if [[ `hostname` == 'Jared.local' ]]; then
    if [[ `uname` == 'Darwin' ]]; then
	export CPPFLAGS=-Qunused-arguments
	export CFLAGS=-Qunused-arguments
	export PATH=$PATH:$HOME/khan/devtools/arcanist/khan-bin
	. ~/.virtualenv/khan27/bin/activate
    fi
fi

alias j='jshint --verbose'
alias ja='j lib *.js'
alias m='mocha -R spec'
alias ip=ipython
alias m='mocha -R spec'
alias j='jshint --verbose'
alias ja='j . lib test'
alias vs='vim --servername'
alias khanv='. ~/.virtualenv/khan27/bin/activate'

export GOPATH=/home/jared/go
# always run ls after cd
function chpwd() {
    emulate -L zsh
    ls -a
}

export ZSH_THEME=gallifrey
# . $ZSH/oh-my-zsh.sh

[[ -s ~/.nvm/nvm.sh ]] && . ~/.nvm/nvm.sh 2>&/dev/null

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export PATH=/Users/jared/khan/devtools/khan-linter/bin:/Users/jared/khan/devtools/ka-clone/bin:/Users/jared/khan/devtools/git-workflow/bin:/Users/jared/khan/devtools/git-bigfile/bin:/Users/jared/khan/devtools/arcanist/khan-bin:/Users/jared/khan/webapp/third_party/frankenserver:$PATH
export PATH=/Users/jared/Library/Android/sdk/tools/:$PATH
export ANDROID_HOME=/Users/jared/Library/Android/sdk
export PATH=/Applications/Julia-0.3.11.app/Contents/Resources/julia/bin:$PATH
