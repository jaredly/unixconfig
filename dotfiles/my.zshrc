
##########################
#### All of the aliai ####
##########################

unalias rm
unalias cp
unalias mv

alias lsd='ls -ld *(-/DN)'
alias lsa='ls -ld .*'

alias gits="git status"
alias gitsn="git status|grep 'Changed but not updated:' -A 1000|grep 'modified:\|deleted:'"
alias gitn="git status|grep 'Untracked files:' -A 1000|grep ^#$'\t'|sed -e 's/^#\t//'"
alias gitca="git commit -am"
alias gitc="git commit -m"
alias gitd='git diff'

alias g=git
alias gm="git commit -m"
alias gc="git commit"
alias gca="git commit -a"
alias ga="git commit -a"
alias gam="git commit --amend"
alias gaam="git commit -a --amend"
alias gad="git add"
alias gd="git diff"
alias gs="git status"
alias gco="git checkout"
alias gpnp='git pull && git push'
alias gsu="git submodule update --init --recursive"

alias hs='hg st'
alias hc='hg commit -m'
alias hd='hg diff'
alias hp='hg pull -u'
alias ll="ls -l"

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
    export CPPFLAGS=-Qunused-arguments
    export CFLAGS=-Qunused-arguments
    # export PATH=$PATH:$HOME/khan/devtools/arcanist/khan-bin
else
    alias open='google-chrome'
    alias ls='ls --color=auto -F'
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
    alias jenkins='java -jar ~/bin/jenkins-cli.jar -s http://ec2-174-129-97-38.compute-1.amazonaws.com:8080/'
    alias sauce='java -jar ~/Downloads/Sauce-Connect-latest/Sauce-Connect.jar jabapyth d99b97a7-abce-4d5a-bdf2-0581775bcdfe'
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

#### More 

preexec () {
    if [[ $WINDOW != "" ]];then
        echo -ne "\ek${PWD/*\//}\e\\"
    fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
