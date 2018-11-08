# remove domain name (.cs.wisc.edu in our case) from hostname, if domain name
# is in hostname (otherwise, just hostname).
export HOSTNAME=`hostname | sed -e s/\\..\*//`

if [ `uname` = "Linux" ]; then
    alias ls="ls -bF --color" 
        # "b" will show control characters as '?'
        # "F" will show a trailing "/" after directories
        # and a "*" after executables
        # --color will do color coding for different file types
    alias grep="grep --color=auto" # default to a colorful grep output.
        # this alias is safe to remove if you prefer plaintext.
elif [ `uname` = "Darwin" ]; then
    alias ls="ls -bFG" # same as linux ls, but --color is -G in OSX
    alias grep="grep --color=auto" # same as linux grep.
else
    alias ls="ls -bF"
fi

if [ "$PS1" ]; then
    set -o ignoreeof # ignore ^D (^D Will not exit the shell)
    set -o noclobber # prevent > to existing files
    set -o notify # Report change in job status

    if [ -n "$TERM" ]; then
        if [ "$TERM" = "xterm" ]; then
            # define 'name', 'icon', and 'title' to allow the user to give
            # xterm windows names by hand.

            function name() { echo -en "\033]0;$@\007"; }
            function icon() { echo -en "\033]1;$@\007"; }
            function title() { echo -en "\033]2;$@\007"; }

            # use xrs (resize) to reset window size after
            # resizing an xterm
            alias xrs='set -o noglob; eval `resize`; unset noglob'
        fi
    fi
fi;

HISTSIZE=1000000
PATH=$PATH:/usr/local/bin
EDITOR=vim
VIMRUNTIME=~/.vim

# Golang related enviroment variables
PATH=$PATH:/usr/local/go/bin:~/go/bin
export GOPATH=~/go

# set a fancy prompt
#PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
BLU="\[\033[0;34m\]" #Blue.
LGY="\[\033[0;37m\]" #Light Gray.
LGR="\[\033[1;32m\]" #Light Green.
LBU="\[\033[1;34m\]" #Light Blue.
LCY="\[\033[1;36m\]" #Light Cyan.
LRE="\[\033[1;31m\]" #Light Red.
YEL="\[\033[1;33m\]" #Yellow.
WHT="\[\033[1;37m\]" #White.
RED="\[\033[0;31m\]" #Red.
OFF="\[\033[0m\]"    #None.
LASTSTAT="\$(if [ \$? -eq 0 ] ; then echo -n '${LGR}:)${LBU}' ; else echo -n '${LRE}:(${LBU}' ; fi )"
#PS1="${LASTSTAT} ${BLU}[${LGR}\H${OFF}${BLU}][${LCY}\w${BLU}]${LBU}\$${OFF} "
PS1="${LASTSTAT} ${debian_chroot:+($debian_chroot)}${YEL}\u${LBU}@\h:${LCY}\w${LBU}\$${OFF} "

# Additional alias
alias ssh='ssh -o ServerAliveInterval=120'
