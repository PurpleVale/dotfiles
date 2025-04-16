# Dependancies You Need for this Config
# zsh-syntax-highlighting - syntax highlighting for ZSH in standard repos
# autojump - jump to directories with j or jc for child or jo to open in file manager
# zsh-autosuggestions - Suggestions based on your history

# Initial Setup
# mkdir -p "$HOME/.zsh"
# Setup Alias in $HOME/.zsh/aliasrc

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
# _comp_options+=(globdots)               # Include hidden files.

# Enable colors and change prompt:
autoload -U colors && colors
# autoload -U promptinit && promptinit
source /home/vale/.zsh/git-prompt.zsh/git-prompt.zsh
source /usr/share/timer.plugin.zsh/timer.plugin.zsh

export LANG=en_US.UTF-8

PROMPT='%B❲$TIMER_LAST:$?%{$fg[blue]%}│%{$fg[magenta]%}%n%{$fg[blue]%}@%{$fg[magenta]%}%M %{$fg[cyan]%}%1~%{$reset_color%}❳ ➜%b '
PROMPT2='%B❲$TIMER_LAST:$?%{$fg[blue]%}│%{$fg[magenta]%}%n%{$fg[blue]%}@%{$fg[magenta]%}%M %{$fg[cyan]%}%1~%{$reset_color%}❳ ↳%b '
RPROMPT='$(gitprompt)'
ZSH_THEME_GIT_PROMPT_PREFIX="❲" 
ZSH_THEME_GIT_PROMPT_SUFFIX="❳"
ZSH_THEME_GIT_PROMPT_SEPARATOR="│"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%} "
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[blue]%} "
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[yellow]%} "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%} "
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%} "
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%} "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[gray]%} "
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} "
TIMER_FORMAT='%d'
TIMER_PRECISION=0
TIMER_THRESHOLD_1=30
TIMER_THRESHOLD_2=120
# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt HIST_FIND_NO_DUPS    # no duplicati nella ricerca nella history
setopt HIST_IGNORE_ALL_DUPS # no duplicati nella history
setopt INC_APPEND_HISTORY_TIME


# Custom ZSH Binds
bindkey '^ ' autosuggest-accept

r-delregion() {
  if ((REGION_ACTIVE)) then
     zle kill-region
  else 
    local widget_name=$1
    shift
    zle $widget_name -- $@
  fi
}

r-deselect() {
  ((REGION_ACTIVE = 0))
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

r-select() {
  ((REGION_ACTIVE)) || zle set-mark-command
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

for key     kcap   seq        mode   widget (
    sleft   kLFT   $'\e[1;2D' select   backward-char
    sright  kRIT   $'\e[1;2C' select   forward-char
    sup     kri    $'\e[1;2A' select   up-line-or-history
    sdown   kind   $'\e[1;2B' select   down-line-or-history

    send    kEND   $'\E[1;2F' select   end-of-line
    send2   x      $'\E[4;2~' select   end-of-line

    shome   kHOM   $'\E[1;2H' select   beginning-of-line
    shome2  x      $'\E[1;2~' select   beginning-of-line

    left    kcub1  $'\EOD'    deselect backward-char
    right   kcuf1  $'\EOC'    deselect forward-char

    end     kend   $'\OOF'    deselect end-of-line
    end2    x      $'\E4~'    deselect end-of-line

    home    khome  $'\EOH'    deselect beginning-of-line
    home2   x      $'\E1~'    deselect beginning-of-line

    csleft  x      $'\E[1;6D' select   backward-word
    csright x      $'\E[1;6C' select   forward-word
    csend   x      $'\E[1;6F' select   end-of-line
    cshome  x      $'\E[1;6H' select   beginning-of-line

    cleft   x      $'\E[1;5D' deselect backward-word
    cright  x      $'\E[1;5C' deselect forward-word

    del     kdch1   $'\E[3~'  delregion delete-char
    bs      x       $'^?'     delregion backward-delete-char

  ) {
  eval "key-$key() {
    r-$mode $widget \$@
  }"
  zle -N key-$key
  bindkey ${terminfo[$kcap]-$seq} key-$key
}

# Auto cd
setopt  autocd autopushd pushdignoredups

# Load aliases and shortcuts if existent.
[ -f "$HOME/.zsh/aliasrc" ] && source "$HOME/.zsh/aliasrc"

# Load ; should be last.
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/autojump/autojump.zsh 2>/dev/null

# PATH
# export PATH=/home/vale/.bin:/home/vale/.screenlayout:/home/vale/.local/bin:$PATH
export PATH=$PATH:/home/vale/.local/bin

# MAN COMMAND USE VIM
export MANPAGER='vim -R -M +MANPAGER -'

hide(){
    mv "$1" ".$1"
}

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
