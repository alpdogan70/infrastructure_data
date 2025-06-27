# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#source /usr/local/bin/kube-ps1.sh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


echo -e '\033[0;32m
██╗░░██╗░█████╗░██╗░░░██╗██╗░░██╗██╗
╚██╗██╔╝██╔══██╗██║░░░██║██║░██╔╝██║
░╚███╔╝░███████║╚██╗░██╔╝█████═╝░██║
░██╔██╗░██╔══██║░╚████╔╝░██╔═██╗░██║
██╔╝╚██╗██║░░██║░░╚██╔╝░░██║░╚██╗██║
╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝
'

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi


export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1


if git --version &>/dev/null; then
#source ~/.bash_git
#PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\] \u\[\033[0;36m\]@\[\033[0;36m\]\h \w\[\033[0;32m\]$(__git_ps1) $(kube_ps1) \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '
PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\] staner\[\033[0;36m\] \w\[\033[0;32m\]$(__git_ps1) \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '
else
#PS1='\033[01;32m\u@\h\033[01;34m \w \$\033[00m '
PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\]@\[\033[0;36m\]\h \w\[\033[0;32m\] \n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]  ▶\[\033[0m\] '
fi


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias vf='cd /home/oki/gitlab.com/vagrant_files/'
alias pres='cd /home/oki/gitlab.com/'
alias ll='ls -laFh --color=auto'
alias la='ls -A'
alias l='ls -larth'
alias gl='git log'
alias gst='git status'
alias gfun="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Cblue - %cn %Creset' --abbrev-commit --date=relative"
alias gg='git log --oneline --all --graph --name-status'
alias dns='rdesktop <server> -g 1500x1024 -d <domain> -u salih.taner -p-'
alias p='sudo su - postgres'
alias s='sudo -s'
alias agent="eval 'ssh-agent -s'"
alias d="docker"
alias dps="docker ps -a"
alias drm="docker rm -f"
#alias dockip='for i in $(docker ps -q); do docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} - {{.Name}}" $i;done'
alias okikif='firefox &'
alias python='/usr/bin/python3'
alias v='vagrant'
alias vu='vagrant up'
alias vs='vagrant ssh'
alias c='clear'
alias tf='terraform'

dockip(){
docker ps -q | awk '{system("docker inspect -f \"{{.NetworkSettings.IPAddress}} - {{.Name}}\" "$1)}'
}

#'git checkout -b <branch> --track <remote>/<branch>'

mkcd(){
mkdir $1 && cd $1
}

ct() { cd $1; tree -L 2; }
export -f ct

up() { if [ "${1/[^0-9]/}" == "$1" ]; then p=./; for i in $(seq 1 $1); do p=${p}../; done; cd $p;else echo 'usage: up N'; fi }
export -f up

drawio() {
docker run -it --rm --name="draw" -p 8080:8080 -p 8443:8443 fjudith/draw.io
}

wx(){
for ID in $(xsetwacom list | cut -f2 | cut -d' ' -f2); do xsetwacom set "$ID" maptooutput next; done
}
export -f wx

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

procdump () 
{ 
    cat /proc/$1/maps | grep -Fv ".so" | grep " 0 " | awk '{print $1}' | ( IFS="-"
    while read a b; do
        ad=$(printf "%llu" "0x$a")
        bd=$(printf "%llu" "0x$b")
        dd if=/proc/$1/mem bs=1 skip=$ad count=$(( bd-ad )) of=$1_mem_$a.bin
    done )
}



# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Effacer l'écran
#clear

echo -e '\e[90m-------------'
# Affichage version OS
echo $(lsb_release -a 2>/dev/null|grep Description)
uptime


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/oki/.sdkman"
[[ -s "/home/oki/.sdkman/bin/sdkman-init.sh" ]] && source "/home/oki/.sdkman/bin/sdkman-init.sh"

#mkvmerge -o 1.9-vagrant-jenkins.mkv okiki-2020-02-10_06.43.35.mkv +okiki-2020-02-10_07.12.29.mkv
#sudo ntfsfix /dev/sda1

complete -C '/home/oki/.local/bin/aws_completer' aws

alias scan='nmap -sP 192.168.1.1/24'


alias k='kubectl'
alias kcc='kubectl config current-context'
alias kg='kubectl get'
alias kga='kubectl get all --all-namespaces'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias ksgp='kubectl get pods -n kube-system'
alias kss='kubectl get services -n kube-system'
alias kuc='kubectl config use-context'
alias kx='kubectx'
alias kn='kubens'
alias h='helm'

