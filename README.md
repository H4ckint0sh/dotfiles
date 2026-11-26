# .dotfiles

This is my dotfiles for MacOS.

> [!NOTE]
> This has only been tested on MacOS.

![Rift](screenshots/Screenshot.png)

## Setup

### Install

```
git clone --recursive git@github.com:H4ckint0sh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x quickstart.sh
sh quickstart.sh
```

### Uninstall

Run `./cleanenv` to unlink the configs.

## Apps

- Text editors: [Neovim](https://neovim.io/)
- Terminal and multiplexer: [Rex](https://www.superlogical.com/rex)
- Window manager: [Rift](https://github.com/acsandmann/rift) 
- Git TUI: [lazygit](https://github.com/jesseduffield/lazygit)
- Shell: [zsh](https://www.zsh.org)
- Prompt: [oh-my-posh](https://ohmyposh.dev/)
- Symlink manager: [stow](https://www.gnu.org/software/stow/)
- Better cat: [bat](https://github.com/sharkdp/bat)
- Better ls: [eza](https://github.com/eza-community/eza)
- Key remapping: [karabiner-elements](https://karabiner-elements.pqrs.org/)

## Bin Scripts

Custom scripts in `bin/bin/`:

- `rex-cht` - Rex cheat sheet
- `rex-font` - Rex font management
- `rex-fzf-url` - Rex fzf URL opener
- `rex-session-init` - Rex session initialization
- `rift-aerospace` - Rift/AeroSpace workspace sync
- `of` - Open file with fzf
- `update` - Update dotfiles and packages

## Structure

```
.dotfiles/
├── bash/               # Bash configuration
├── bat/                # bat themes/config
├── bin/                # Custom scripts (stowed to ~/.local/bin)
├── exported-defaults/  # macOS defaults export
├── eza/                # eza configuration
├── git/                # Git configuration
├── gitu/               # gitu configuration
├── helix/              # Helix editor config
├── karabiner/          # Karabiner-Elements config
├── lazygit/            # lazygit config
├── nvim/               # Neovim config (lazy.nvim)
├── ohmyposh/           # oh-my-posh themes
├── rex/                # Rex terminal multiplexer config
├── rift/               # Rift window manager config
├── ssh/                # SSH config
├── wallpapers/         # Wallpaper images
├── zed/                # Zed editor config
├── zsh/                # Zsh configuration
├── quickstart.sh       # Main setup script (self-contained)
├── import-defaults.sh  # Import macOS defaults
├── cleanenv            # Unlink all stow folders
└── Brewfile            # Homebrew bundle
```
