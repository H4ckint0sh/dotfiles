#!/usr/bin/env zsh

# ~/.zshrc - Optimized ZSH Configuration with Zinit
# ================================================

# ================================
# Performance Optimization
# ================================
# Enable profiling (uncomment to debug slow startup)
# zmodload zsh/zprof

# Compile zcompdump for faster startup
if [[ -f ~/.zcompdump && ! -f ~/.zcompdump.zwc ]]; then
  zcompile ~/.zcompdump
fi

# ================================
# Zinit Installation & Setup
# ================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# ================================
# ZSH Options & Settings
# ================================

# History Configuration
HISTFILE=~/.zsh_history
export HISTIGNORE="rm -rf*:ls:echo:ll:gallery-dl:c"
HISTSIZE=100000000000
SAVEHIST=$SAVEHIST
setopt EXTENDED_HISTORY APPEND_HISTORY HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS
setopt HIST_VERIFY SHARE_HISTORY INC_APPEND_HISTORY

# ================================
# Environment Variables
# ================================
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export BAT_CONFIG_PATH="$HOME/.config/bat/config"
export BAT_THEME="Nord"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ================================
# PATH Configuration (Optimized)
# ================================

# Core paths
typeset -U path  # Keep PATH unique
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
    "$HOME/.node/bin"
    "$HOME/.dotnet/tools"
    "$HOME/.config/sesh/scripts"
    "$HOME/.cargo/bin"
    "$HOME/.yarn/bin"
    "$HOME/.config/yarn/global/node_modules/.bin"
    "$HOME/Library/pnpm"
    $path
)

export PNPM_HOME="$HOME/Library/pnpm"

# ================================
# Homebrew Completion Setup
# ================================
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# ================================
# Zinit Plugin Loading (Optimized)
# ================================

# Initialize completion system
autoload -Uz compinit

# Simple optimization: use cached completions if available
if [[ -f ~/.zcompdump ]]; then
    compinit -i -C
else
    compinit -i
fi

# Load zsh-vi-mode lazily
zinit ice lucid depth=1
zinit light jeffreytse/zsh-vi-mode
bindkey -v  # Enable vi keybindings

# FZF Tab - Lazy load
zinit ice lucid wait"0"
zinit light Aloxaf/fzf-tab

# Oh My Posh with deferred loading
zinit ice lucid wait"0"
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.toml)"

# Syntax highlighting (deferred)
zinit ice lucid wait"0" atinit"zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting
zle_highlight=('paste:none')

# FZF - Lazy load with precompiled resources
zinit ice as"command" from"gh-r" lucid \
    compile"shell/{completion,key-bindings}.zsh" wait"1"
zinit light junegunn/fzf


# Zoxide - Lazy load with precompiled initialization
zinit ice as"command" from"gh-r" lucid \
    atclone"./zoxide init --cmd cd zsh > init.zsh" src"init.zsh" compile"init.zsh" wait"1"
zinit light ajeetdsouza/zoxide

# FNM - Lazy load with environment setup
zinit ice as"command" from"gh-r" lucid \
    atload'eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"' wait"2"
zinit light Schniz/fnm

# Autosuggestions (deferred)
zinit ice lucid wait"2" atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# ================================
# Tool Configuration
# ================================

# FZF Configuration
export FZF_DEFAULT_OPTS="
    --height=40%
    --highlight-line
    --info=inline-right
    --ansi
    --layout=reverse
    --color=fg:#616E88,fg+:#D8DEE9,bg:-1,bg+:-1
    --color=hl:#5E81AC,hl+:#81A1C1,info:#81A1C1
    --color=marker:#B48EAD,prompt:#B48EAD,spinner:#B48EAD
    --color=pointer:#D8DEE9,header:#D08770,border:#616E88
    --color=label:#D8DEE9,query:#E5E9F0"

# Autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#616E88"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Vi-mode configuration
ZVM_VI_HIGHLIGHT_BACKGROUND="#3B4252"

# ================================
# Completion System Configuration
# ================================

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completions

# FZF-tab styling
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' popup-min-size 80 10
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
zstyle ':fzf-tab:*' fzf-flags --pointer '▶' --prompt '  ' --color=fg:#616E88,fg+:#D8DEE9,pointer:#D8DEE9,border:#616E88,prompt:#B48EAD,info:#D08770,hl:#5E81AC,hl+:#81A1C1,bg:-1,bg+:-1

# SSH completion
if [[ -r ~/.ssh/known_hosts ]]; then
    h=($(cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e 's/,.*//g' | uniq))
    zstyle ':completion:*:(ssh|scp|rsync):*' hosts $h
fi

# ================================
# Key Bindings
# ================================
zvm_after_init() {
    # History search
    bindkey '^p' history-search-backward
    bindkey '^n' history-search-forward
    bindkey '^[w' kill-region
}

# ================================
# Useful Functions
# ================================

# PR checkout function
prs() {
    GH_FORCE_TTY=100% gh pr list --limit 300 |
        fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view --comments {1}' \
            --preview-window 'down,70%' --header-lines 3 |
        awk '{print $1}' | xargs gh pr checkout
}

# ================================
# Load Custom Configuration
# ================================

# Load alias files
if [[ -d ~/.zsh-aliases ]]; then
    for config_file in ~/.zsh-aliases/*.zsh; do
        [[ -f "$config_file" ]] && source "$config_file"
    done
fi

# Local machine specific config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ================================
# Compile Configuration for Speed
# ================================
# Compile .zshrc for faster loading
if [[ ! -f ~/.zshrc.zwc ]] || [[ ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile ~/.zshrc &!
fi

# ================================
# Performance Optimization
# ================================
# Enable profiling (uncomment to debug slow startup)
# zprof
