# ---------------------- local utility functions ---------------------

_have()      { type "$1" &>/dev/null; }
_source_if() { [[ -r "$1" ]] && source "$1"; }

# ----------------------- set vi mode ----------------------

bindkey -v

# ----------------------- environment variables ----------------------

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
export PAGER=less
export KUBECONFIG="$HOME/.kube/config"

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;34m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;33m'
export LESS=-r

export GROFF_NO_SGR=1

export ABBR_USER_ABBREVIATIONS_FILE="$HOME/.local/share/zsh/abbreviations"

if [ -f ~/.local/share/zsh/secrets ]; then
  source ~/.local/share/zsh/secrets
fi

# --------------------- plugins -------------------------

source "$HOME/.local/share/zsh/zsh-z/zsh-z.plugin.zsh"
source "$HOME/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.local/share/zsh/zsh-abbr/zsh-abbr.zsh"

ZSH_HIGHLIGHT_REGEXP+=('^[[:blank:][:space:]]*('${(j:|:)${(k)ABBR_REGULAR_USER_ABBREVIATIONS}}')$' fg=blue)
ZSH_HIGHLIGHT_REGEXP+=('\<('${(j:|:)${(k)ABBR_GLOBAL_USER_ABBREVIATIONS}}')$' fg=blue)
# ----------------------------- completion ----------------------------

zstyle ':completion:*' menu select

# Auto complete with case insensitivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

autoload -Uz compinit && compinit

# ------------------------- asdf --------------------------------

. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)
fpath=(~/.local/share/zsh/completion $fpath)

# ----------------------------- prompt ----------------------------

autoload -Uz add-zsh-hook
autoload -Uz vcs_info

add-zsh-hook precmd vcs_info

zstyle ':vcs_info:git:*' formats '%F{black}(%F{red}%b%F{black})'
zstyle ':vcs_info:git:*' formats '%F{black}(%F{red}%b%F{black})'

setopt PROMPT_SUBST
PROMPT='%F{yellow}%n%F{black}@%F{green}%m%F{black}:%F{magenta}%(3~|.../%2~|%~)${vcs_info_msg_0_}%F{yellow}%(!.#.$)%f '

# ------------------------------ history -----------------------------

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# ---------------------------- key bindings ----------------------------

autoload edit-command-line; zle -N edit-command-line

zle-keymap-select() {
  if [[ $KEYMAP = vicmd ]]; then
    print -n "\e[2 q"
  else
    print -n "\e[5 q"
  fi
}

zle-line-init() {
  zle -K viins
  echo -ne "\e[5 q"
}

preexec() { echo -ne "\e[5 q" ; }

zle -N zle-keymap-select
zle -N zle-line-init

export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M vicmd 'k' history-search-backward
bindkey -M vicmd 'j' history-search-forward
bindkey -M menuselect '^[' undo


bindkey "^F" end-of-line
bindkey "^?" backward-delete-char
bindkey "^e" edit-command-line

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

# ----------------------- aliases / abbrs -----------------------

alias '?'=duck
alias '??'=google

zstyle :compinstall filename '/home/ceres/.zshrc'

autoload -Uz compinit && compinit

_comp_options+=(globdots) # With hidden files
source <(kubectl completion zsh)



###!!! THIS MUST BE LAST !!!###
source "$HOME/.local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

complete -o nospace -C /usr/bin/packer packer
