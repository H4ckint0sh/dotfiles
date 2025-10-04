# !/usr/bin/env zsh

# ~/.zshrc - Optimized ZSH Configuration
# ================================================

# ================================
# Performance Optimization
# ================================
# Enable profiling (uncomment to debug slow startup)
zmodload zsh/zprof

# Compile zcompdump for faster startup
if [[ -f ~/.zcompdump && ! -f ~/.zcompdump.zwc ]]; then
    zcompile ~/.zcompdump
fi

# SSH Agent Management
ssh_agent_lazy() {
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        eval "$(ssh-agent -s)" > ~/.ssh/agent.env
        source ~/.ssh/agent.env
    fi
    if ! ssh-add -l >/dev/null 2>&1; then
        ssh-add --apple-load-keychain 2>/dev/null
    fi
}

# ================================
# ZSH Options & Settings
# ================================

# Directory Navigation
setopt AUTO_CD              # Type directory name to cd
setopt AUTO_PUSHD           # Push directories to stack on cd
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_SILENT         # Don't print directory stack
setopt CDABLE_VARS          # cd to variable values

# History Configuration
HISTFILE=~/.zsh_history
export HISTIGNORE="rm -rf*:ls:echo:ll:gallery-dl:c"
HISTSIZE=50000
SAVEHIST=50000
HISTDUP=erase
setopt EXTENDED_HISTORY          # Write timestamp to history
setopt APPEND_HISTORY            # Append to history file
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded duplicates
setopt HIST_FIND_NO_DUPS         # Don't display duplicates
setopt HIST_IGNORE_SPACE         # Don't record lines starting with space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
setopt HIST_VERIFY               # Show command before executing from history
setopt SHARE_HISTORY             # Share history between sessions
setopt INC_APPEND_HISTORY        # Add to history immediately

# Completion System
setopt COMPLETE_IN_WORD     # Complete from cursor position
setopt ALWAYS_TO_END        # Move cursor to end after completion
setopt PATH_DIRS            # Search path for completions
setopt AUTO_MENU            # Show completion menu
setopt AUTO_LIST            # List choices on ambiguous completion
setopt AUTO_PARAM_SLASH     # Add trailing slash for directories
setopt MENU_COMPLETE        # Cycle through completions
setopt NO_BEEP              # Disable beeping

# Job Control
setopt NO_BG_NICE           # Don't nice background jobs
setopt NO_HUP               # Don't kill jobs on shell exit
setopt NO_CHECK_JOBS        # Don't warn about background jobs on exit
setopt LONG_LIST_JOBS       # List jobs in long format

# Globbing and Expansion
setopt EXTENDED_GLOB        # Enable extended globbing
setopt GLOB_DOTS            # Include dotfiles in globbing
setopt NO_CASE_GLOB         # Case-insensitive globbing
setopt NUMERIC_GLOB_SORT    # Sort numerically when relevant
setopt NO_GLOB_COMPLETE     # Don't expand globs on tab

# Input/Output
setopt CORRECT               # Correct command spelling
setopt CORRECT_ALL           # Correct all arguments
setopt INTERACTIVE_COMMENTS  # Allow comments in interactive shell
setopt RC_QUOTES             # Allow 'Henry's Garage'
setopt MAIL_WARNING          # Warn if mail file accessed

# ================================
# Environment Variables
# ================================

# Set default editor
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"

# path to bat Configuration
export BAT_CONFIG_PATH="$HOME/.config/bat/config"
export BAT_THEME="Nord"

# Set locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ================================
# PATH Configuration
# ================================

# Function to add to PATH (avoids duplicates)
add_to_path() {
    if [[ -d "$1" && ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Add local paths
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"
add_to_path "/usr/local/bin"
add_to_path "/opt/homebrew/bin"
add_to_path "/opt/homebrew/sbin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.node/bin"
add_to_path "$HOME/.dotnet/tools"
add_to_path "$HOME/.config/sesh/scripts"
add_to_path "$HOME/.cargo/bin"

# Yarn
add_to_path "$HOME/.yarn/bin"
add_to_path "$HOME/.config/yarn/global/node_modules/.bin"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
add_to_path "$PNPM_HOME"



# ================================
# Tool Initializations
# ================================

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --height=40% \
    --highlight-line \
    --info=inline-right \
    --ansi \
    --layout=reverse \
    --color=fg:#616E88 \
    --color=fg+:#D8DEE9 \
    --color=bg:-1 \
    --color=bg+:-1 \
    --color=hl:#5E81AC \
    --color=hl+:#81A1C1 \
    --color=info:#81A1C1 \
    --color=marker:#B48EAD \
    --color=prompt:#B48EAD \
    --color=spinner:#B48EAD \
    --color=pointer:#B48EAD \
    --color=header:#D08770 \
    --color=border:#616E88 \
    --color=label:#D8DEE9 \
    --color=query:#E5E9F0 \
    "
eval "$(fzf --zsh)"

# ohmyposh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.toml)"

# zoxide
eval "$(zoxide init --cmd cd zsh)"


# Lazy-load fnm only when a Node command is run for the first time
_fnm_lazy_load() {
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
    unset -f node npm npx yarn pnpm _fnm_lazy_load
}

for cmd in node npm npx yarn pnpm; do
    eval "
    $cmd() {
        _fnm_lazy_load
        $cmd \"\$@\"
    }
"
done

# ================================
# Completion System Configuration
# ================================

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi

# Initialize completion system
autoload -Uz compinit

# Simple optimization: use cached completions if available
if [[ -f ~/.zcompdump ]]; then
    compinit -C  # Skip security check for faster startup
else
    compinit
fi

# Compile the dump file if needed for faster loading
if [[ -f ~/.zcompdump && ! -f ~/.zcompdump.zwc ]] || [[ ~/.zcompdump -nt ~/.zcompdump.zwc ]]; then
    zcompile ~/.zcompdump &!  # Compile in background
fi

# Completion styling
# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-flags "--color=fg:#616E88,fg+:#D8DEE9,bg:-1,bg+:-1"
zstyle ':fzf-tab:*' popup-min-size 80 10
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completions

# Better SSH/SCP/RSYNC completion
if [[ -r ~/.ssh/known_hosts ]]; then
    h=($( cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e 's/,.*//g' | uniq ))
    zstyle ':completion:*:(ssh|scp|rsync):*' hosts $h
fi

# Kill command completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
    zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ================================
# Key Bindings
# ================================

# Enable vi mode 
bindkey -v

# History search CTRL+P/CTRL+N
function zvm_after_init() {
    bindkey '^p' history-search-backward
    bindkey '^n' history-search-forward
    bindkey '^[w' kill-region
}

# ================================
# Useful Functions
# ================================

function prs {
    GH_FORCE_TTY=100% gh pr list --limit 300 |
        fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view --comments {1}' --preview-window 'down,70%' --header-lines 3 |
        awk '{print $1}' |
        xargs gh pr checkout
    }

# ================================
# Syntax Highlighting & Autosuggestions
# ================================

# Install with: brew install zsh-syntax-highlighting zsh-autosuggestions
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    bindkey '^Y' autosuggest-accept  # Ctrl+Y to accept suggestion
fi

# fzf-tab
if [[ -f /opt/homebrew/share/fzf-tab/fzf-tab.plugin.zsh ]]; then
    source  /opt/homebrew/share/fzf-tab/fzf-tab.plugin.zsh
fi

if [[ -f /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]; then
    source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi

# ================================
# Load Custom Aliases Files
# ================================

# Load all alias files from ~/.zsh-aliases/
if [[ -d ~/.zsh-aliases ]]; then
    for config_file in ~/.zsh-aliases/*.zsh; do
        [[ -f "$config_file" ]] && source "$config_file"
    done
fi

# ================================
# Local Machine Specific Config
# ================================

# Source local config if exists (not tracked in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ================================
# Welcome Message
# ================================

# Display system info on new shell (optional)
if command -v fastfetch &>/dev/null; then
    fastfetch --logo small
elif command -v neofetch &>/dev/null; then
    neofetch --ascii_distro mac_small
fi

# ================================
# Performance Profiling
# ================================

# Uncomment to see startup time analysis
# zprof
