# A smart and user-friendly command line
# https://fishshell.com

starship init fish | source # https://starship.rs/
zoxide init fish | source # 'ajeetdsouza/zoxide'
thefuck --alias | source # thefuck 

# set -gx PNPM_HOME /Users/ali/Library/pnpm # https://pnpm.io/
set -Ux DOTFILES /Users/ali/.dotfiles 
set -Ux HELIX_RUNTIME /Users/ali/Desktop/projects/helix/runtime 
set -Ux BAT_THEME Nord # 'sharkdp/bat' cat clone 
set -Ux EDITOR hx # 'neovim/neovim' text editor 
set -Ux fish_greeting # disable fish greeting
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -Ux LANG en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8
set -Ux NODE_PATH ~/.local/share/nvm/v18.16.1/bin/node
set -Ux VISUAL hx

# ordered by priority - bottom up
fish_add_path /usr/local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/sbin
fish_add_path $HOME/.cargo/bin
fish_add_path $PNPM_HOME
fish_add_path $DOTFILES
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.tmux/plugins/t-smart-tmux-session-manager/bin
fish_add_path $HOME/bin # my custom scripts
fish_add_path $HOME/.nvm/versions/node/v18.16.1/bin
fish_add_path $HOME/.local/share/nvm/v18.16.1/bin

