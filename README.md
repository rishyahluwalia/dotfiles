# dotfiles

Personal macOS dotfiles. Each top-level directory holds one tool's config, deployed by symlinking into its standard location (there is no installer — see below).

## What's in here

| Dir / file              | Tool         | What it is                                                                 |
| ----------------------- | ------------ | -------------------------------------------------------------------------- |
| `nvim/`                 | Neovim       | Editor — a [LazyVim](https://lazyvim.org) config (see `nvim/CLAUDE.md`).    |
| `tmux/`                 | tmux         | Terminal multiplexer — config + `scripts/` for the status bar.             |
| `tmuxinator/`           | tmuxinator   | Declarative tmux session/window layouts (`honey.yml` is the work session). |
| `starship.toml`         | Starship     | Cross-shell prompt.                                                        |
| `ghostty/`              | Ghostty      | Primary terminal emulator.                                                 |
| `alacritty/`            | Alacritty    | Alternate terminal emulator.                                               |
| `yazi/`                 | Yazi         | Terminal file manager.                                                     |
| `vscode/`               | VS Code      | `settings.json` + `keybindings.json`.                                      |

## Install external dependencies

On macOS with [Homebrew](https://brew.sh):

```sh
# Terminals + multiplexer + prompt + file manager
brew install --cask ghostty
brew install tmux starship yazi alacritty
gem install tmuxinator                 # or: brew install tmuxinator

# Neovim + LazyVim runtime requirements
brew install neovim git ripgrep fd     # rg + fd power LazyVim's pickers
brew install lazygit                   # optional, used by the git UI
brew install --cask font-jetbrains-mono-nerd-font   # the font the terminals expect
```

LazyVim also wants a C compiler + `make` (for `nvim-treesitter`) — these come with the Xcode Command Line Tools (`xcode-select --install`). Language servers/formatters are installed on demand by Mason inside Neovim; many need `node`/`npm` on your `PATH`.

## Symlink the configs

There is **no setup script.** Symlink each config into place (adjust the repo path if you cloned elsewhere — these assume `~/code/personal/dotfiles`):

```sh
DOTFILES=~/code/personal/dotfiles
mkdir -p ~/.config/ghostty

# Neovim, tmux, yazi: symlink the whole directory
ln -sfn "$DOTFILES/nvim"        ~/.config/nvim
ln -sfn "$DOTFILES/tmux"        ~/.config/tmux        # tmux.conf reads scripts/ from here
ln -sfn "$DOTFILES/yazi"        ~/.config/yazi
ln -sfn "$DOTFILES/tmuxinator"  ~/.config/tmuxinator
ln -sfn  "$DOTFILES/alacritty"  ~/.config/alacritty
ln -sfn  "$DOTFILES/ghostty"    ~/.config/ghostty

# Single-file configs
ln -sf  "$DOTFILES/starship.toml" ~/.config/starship.toml

# VS Code (macOS user-config dir)
VSCODE=~/Library/Application\ Support/Code/User
ln -sf "$DOTFILES/vscode/vscode-settings.json"    "$VSCODE/settings.json"
ln -sf "$DOTFILES/vscode/vscode-keybindings.json" "$VSCODE/keybindings.json"
```

Then point Starship at its config in your shell rc (`eval "$(starship init zsh)"`) and reload tmux with `prefix` + `r`.
