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
      --color=bg:#1a1b26 \
      --color=bg+:#1a1b26
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

# Set neovim as EDITOR
export EDITOR=nvim

# Gemini API Key
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
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::brew
zinit snippet OMZP::tmux
zinit snippet OMZP::yarn
zinit snippet OMZP::npm
zinit ice lucid wait
zinit snippet OMZP::fzf
zinit snippet OMZP::frontend-search

# Load completions
autoload -Uz compinit && compinit

#vi modep
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Keybindings
# The plugin will auto execute this zvm_after_init function
function zvm_after_init() {
  bindkey -e
  bindkey '^p' history-search-backward
  bindkey '^n' history-search-forward
  bindkey '^[w' kill-region
}

# History --------------------------------------------------------------
export HISTSIZE=10000000
export HISTIGNORE="rm -rf*:ls:echo:ll:gallery-dl:c"
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
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
zstyle ':fzf-tab:*' fzf-flags --color=fg:#565f89,fg+:#c0caf5,bg:#1a1b26,bg+:#1a1b26


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

# OTHER ALIASES----------------------------------------------------------------
alias v='nvim'
alias lg="lazygit"
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -l"
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
