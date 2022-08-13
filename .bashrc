# .bashrc

# DISTRO DETECTION


# ---------------------- local utility functions ---------------------

_have()      { type "$1" &>/dev/null; }
_source_if() { [[ -r "$1" ]] && source "$1"; }


# ENVIRONMENT VARIABLES
export EDITOR=vi
export VISUAL=vi
export EDITOR_PREFIX=vi
export REPOS="$HOME/Repos"
export GITUSER="AyashiNoCeres"
export GHREPOS="$REPOS/github.com/$GITUSER"
export DOTFILES="$GHREPOS/dot"
export SCRIPTS="$DOTFILES/scripts"
export DESKTOP="$HOME/Desktop"
export DOCUMENTS="$HOME/Documents"
export DOWNLOADS="$HOME/Downloads"
export TEMPLATES="$HOME/Templates"
export PUBLIC="$HOME/Public"
export PRIVATE="$HOME/Private"
export PICTURES="$HOME/Pictures"
export MUSIC="$HOME/Music"
export VIDEOS="$HOME/Videos"
export VIRTUALMACHINES="$HOME/VirtualMachines"
export ZETDIR="$GHREPOS/zet"
export GOPATH="$HOME/.local/share/go"
export GOBIN="$HOME/.local/bin"
export GOPROXY=direct

# ----------------------- environment variables ----------------------


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# # User specific environment
# if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
# then
#     PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# fi
# export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

# ------------------------ bash shell options ------------------------

shopt -s checkwinsize
shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob
shopt -s extglob

# ------------------------------ history -----------------------------

export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTFILESIZE=10000

set -o vi
shopt -s histappend

# ----------------------------- dircolors ----------------------------

if _have dircolors; then
  if [[ -r "$HOME/.dircolors" ]]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi

# ------------------------------- path -------------------------------

pathappend() {
  declare arg
  for arg in "$@"; do
    test -d "$arg" || continue
    PATH=${PATH//":$arg:"/:}
    PATH=${PATH/#"$arg:"/}
    PATH=${PATH/%":$arg"/}
    export PATH="${PATH:+"$PATH:"}$arg"
  done
} && export pathappend

pathprepend() {
  for arg in "$@"; do
    test -d "$arg" || continue
    PATH=${PATH//:"$arg:"/:}
    PATH=${PATH/#"$arg:"/}
    PATH=${PATH/%":$arg"/}
    export PATH="$arg${PATH:+":${PATH}"}"
  done
} && export pathprepend

pathprepend \
  "$HOME/.local/bin" \
  "$GHREPOS/cmd-"* \
  "$SCRIPTS"


# --------------------------- smart prompt ---------------------------
#                 (keeping in bashrc for portability)

PROMPT_LONG=40
PROMPT_MAX=165
PROMPT_AT=@

__ps1() {
  local P='$' dir="${PWD##*/}" B countme short long double\
    r='\[\e[31m\]' g='\[\e[30m\]' h='\[\e[34m\]' \
    u='\[\e[33m\]' p='\[\e[34m\]' w='\[\e[35m\]' \
    b='\[\e[36m\]' x='\[\e[0m\]' z='\[\e[36m\]'

  [[ $EUID == 0 ]] && P='#' && u=$r && p=$u # root
  [[ $PWD = / ]] && dir=/
  [[ $PWD = "$HOME" ]] && dir='~'

  B=$(git branch --show-current 2>/dev/null)
  [[ $dir = "$B" ]] && B=.
  countme="$USER$PROMPT_AT$(hostname):$dir($B)\$ "

  [[ $B = master || $B = main ]] && b="$r"
  [[ -n "$B" ]] && B="$g($b$B$g)"

  short="$u\u$g$PROMPT_AT$z\h$g:$w$dir$B$u$P$x "
  long="$g╔ $u\u$g$PROMPT_AT$z\h$g:$w$dir$B\n$g╚ $u$P$x "
  double="$g╔ $u\u$g$PROMPT_AT$z\h$g:$w$dir\n$g║ $B\n$g╚ $u$P$x "

  if (( ${#countme} > PROMPT_MAX )); then
    PS1="$double"
  elif (( ${#countme} > PROMPT_LONG )); then
    PS1="$long"
  else
    PS1="$short"
  fi
}

PROMPT_COMMAND="__ps1"

_source_if "$HOME/.bash_personal"
_source_if "$HOME/.bash_private"
_source_if "$HOME/.bash_work"

# ----------------------- aliases -----------------------

alias '?'=duck
alias '??'=google
alias temp='cd $(mktemp -d)'
alias scripts='cd $SCRIPTS'


# ------------- source external dependencies / completion ------------

_have gh && . <(gh completion -s bash)
_have podman && . <(podman completion bash)
complete -C zet zet

# ------------------------------ history -----------------------------

export HISTCONTROL=ignoreboth
export HISTSIZE=50000
export HISTFILESIZE=100000

set -o vi
shopt -s histappend

complete -C /usr/bin/terraform terraform

complete -C /usr/bin/packer packer
