if [ $(ps ax | grep "[s]sh-agent" | wc -l) -eq 0 ] ; then
    eval $(ssh-agent -s) > /dev/null
    if [ "$(ssh-add -l)" = "The agent has no identities." ] ; then
        # Auto-add ssh keys to your ssh agent
        # Example:
        ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github > /dev/null 2>&1
        ssh-add --apple-use-keychain ~/.ssh/id_rsa_devops > /dev/null 2>&1
    fi
fi

# FZF --------------------------------------------------------------
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
      --height=40% \
      --highlight-line \
      --info=inline-right \
      --ansi \
      --layout=reverse \
      --color=fg:#565f89 \
      --color=fg+:#c0caf5 \
      --color=bg:#24283b \
      --color=bg+:#24283b
      --color=hl:#3d59a1 \
      --color=hl+:#7aa2f7 \
      --color=info:#7aa2f7 \
      --color=marker:#87ff00 \
      --color=prompt:#ff007c \
      --color=spinner:#bb9af7 \
      --color=pointer:#bb9af7 \
      --color=header:#ff9e64 \
      --color=border:#565f89 \
      --color=label:#c0caf5 \
      --color=query:#d9d9d9 \
"

# Left-pad command output with 2 spaces
precmd() {
  tput cuf 2  # Adds 2 spaces before each command output
}

precmd()

# Node- sass
export SKIP_SASS_BINARY_DOWNLOAD_FOR_CI=true
export SKIP_NODE_SASS_TESTS=true

#job
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

# Path to your dotfiles.
export DOTFILES=$HOME/.dotfiles

# path to bat config
export BAT_CONFIG_PATH="$HOME/.config/bat/config"

# JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home)

# terminal
export TERM=tmux-256color

# PostgresSQL
export PGDATA='/Users/ali/.postgres'

# Set neovim as EDITOR
export EDITOR=nvim

# Gemini API Key
export GEMINI_API_KEY=$(security find-generic-password -s "gemini_api_key" -w)

# DeepSeek API Key
export GEMINI_API_KEY=$(security find-generic-password -s "gemini_api_key" -w)


export ZSH_CUSTOM=$DOTFILES
# export LANG=en_US.UTF-8
# export LC_ALL=$LANG

# Zinit --------------------------------------------------------------
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light jeffreytse/zsh-vi-mode
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found
zinit snippet OMZP::brew
zinit snippet OMZP::tmux
zinit snippet OMZP::yarn
zinit snippet OMZP::npm
zinit snippet OMZP::fzf
zinit snippet OMZP::frontend-search

# Load completions
autoload -Uz compinit && compinit

#The plugin will auto execute this zvm_after_init function
function zvm_after_init() {
  bindkey '^p' history-search-backward
  bindkey '^n' history-search-forward
  bindkey '^[w' kill-region
}

# History --------------------------------------------------------------
export HISTSIZE=10000000
export HISTIGNORE="rm -rf*:ls:echo:ll:gallery-dl:c"
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# fzf options
zstyle ':fzf-tab:*' fzf-flags --color=fg:#565f89,fg+:#c0caf5,bg:#24283b,bg+:#24283b


# FUNCTIONS --------------------------------------------------------------
function fo() {
    hx $(find -type f | fzf -m --preview="bat --color=always --style=numbers --line-range=:500 {}")
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

function prs {
  GH_FORCE_TTY=100% gh pr list --limit 300 |
  fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view --comments {1}' --preview-window 'down,70%' --header-lines 3 |
  awk '{print $1}' |
  xargs gh pr checkout
}

# GIT ALIASES ----------------------------------------------------------------
# Aliases: git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'

# OTHER ALIASES----------------------------------------------------------------
alias v='nvim'
alias lg="lazygit"
alias ls="eza --icons --group-directories-first -1 -T"
alias ll="eza --icons --group-directories-first -l -T"
alias c="clear"
alias kp="ps aux | fzf | awk '{print \$2}' | xargs kill"
alias delds="find . -name ".DS_Store" -type f -delete"
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias mkdir='mkdir -pv'
alias path='echo -e ${PATH//:/\\n} | less'

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=white,fg=black,bold"

#PATH ------------------------------------------------------------------------
export PATH="$HOME/bin:$PATH"
# Load Composer tools
export PATH="$HOME/.composer/vendor/bin:$PATH"
# Load Node global installed binaries
export PATH="$HOME/.node/bin:$PATH"
# Load Node global installed binaries
export PATH="$HOME/.local/bin:$PATH"
# Use project specific binaries before global ones
export PATH="/usr/local/Cellar/llvm/15.0.5/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.config/sesh/scripts:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="/$HOME/.pyenv/shims/djlint:$PATH"

# ohmyposh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.toml)"

# OMP zsh-vi-mode integration
_omp_redraw-prompt() {
  local precmd
  for precmd in "${precmd_functions[@]}"; do
    "$precmd"
  done

  zle .reset-prompt
}

function zshaddhistory() {
  emulate -L zsh
  [[ $1 != *gallery-dl* ]]
}

export POSH_VI_MODE="I"

function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
  $ZVM_MODE_NORMAL)
    POSH_VI_MODE="N"
    ;;
  $ZVM_MODE_INSERT)
    POSH_VI_MODE="I"
    ;;
  $ZVM_MODE_VISUAL)
    POSH_VI_MODE="V"
    ;;
  $ZVM_MODE_VISUAL_LINE)
    POSH_VI_MODE="V-L"
    ;;
  $ZVM_MODE_REPLACE)
    POSH_VI_MODE="R"
    ;;
  esac
  _omp_redraw-prompt
}

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# fzf shell integration
eval "$(fzf --zsh)"

# TheFuck
eval $(thefuck --alias)

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# fnm
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"

# source ~/.transient-prompt.zsh
