# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal macOS dotfiles. Each top-level directory is one tool's config. There is **no build, no test suite, and no installer** — `setup.sh` was a placeholder ("coming soon!") and has been removed. Changes are validated by running the tool itself.

## Keep documentation in sync

After any change to this repo, update the documentation that the change affects — this is part of the change, not a follow-up:

- **Added/removed a tool, or changed where a config is symlinked** → update both `README.md` (the "What's in here" table and the symlink/install steps) and the deployment section of this file.
- **Added an external dependency** (a binary a config now shells out to, a runtime LazyVim needs, etc.) → add it to `README.md`'s "Install external dependencies".
- **Changed something this file describes** (the tmux↔tmuxinator coupling, the migration state, the theming notes, the nvim setup) → update the relevant section here, and `nvim/CLAUDE.md` for anything under `nvim/`.

If you finish a change and nothing in the docs is now wrong or missing, say so explicitly rather than skipping the check silently.

## Deployment model: manual symlinks, not a manager

Configs are **not** copied or managed by a stow/chezmoi-style tool. Each config is expected to be symlinked from this repo into its standard location. There is no master list of symlinks; instead, **the header comment of each ported config documents its own target** (JSON configs like `ccstatusline/` and `vscode/` can't carry a comment, so their targets are listed here), e.g.:

- `tmux/tmux.conf` → `~/.config/tmux/tmux.conf` (the conf reloads via `source-file ~/.config/tmux/tmux.conf`, and tmuxinator reads from `~/.config/tmuxinator/`). tmux uses the XDG path `~/.config/tmux/`, **not** `~/.tmux.conf`.
- `ghostty/config.ghostty` → `~/.config/ghostty/config` — **Ghostty's real config file has no extension**; the `.ghostty` suffix here is only so the repo file is recognizable.
- `alacritty/alacritty.toml` → `~/.config/alacritty/alacritty.toml`.
- `starship.toml` → `~/.config/starship.toml`; `yazi/*` → `~/.config/yazi/`; `tmuxinator/*.yml` → `~/.config/tmuxinator/`.
- `ccstatusline/settings.json` → `~/.config/ccstatusline/settings.json` — config for the `ccstatusline` Claude Code status line (model / context-length / usage / cost widgets). It only takes effect because **Claude Code's own `~/.claude/settings.json` points `statusLine.command` at the `ccstatusline` binary** — that wiring, and the binary itself (a pinned npm global, see README), live outside this repo.

When editing a config, check its header comment for the canonical symlink command before assuming a path.

## Layout is mid-migration (flat → per-tool dirs)

The repo is being reorganized from a flat root (files like `alacritty.yml`, `.tmux.conf`, `init.vim`, `config.fish`, `coc-settings.json` at the top level) into per-tool subdirectories. The git working tree already reflects the **new** layout; the old root files are staged for deletion. Consequences:

- The Neovim config moved from Vimscript (`init.vim` + `coc-settings.json`) to a full Lua **LazyVim** setup under `nvim/`. Do not resurrect the old `init.vim`.
- The **fish shell config (`config.fish`) was removed and is no longer tracked here.** This matters because the `cd*` aliases tmuxinator depends on (see below) live in the shell rc, which is now external to this repo.
- Alacritty's old `alacritty.yml` (deprecated YAML format) is superseded by `alacritty/alacritty.toml`.

Don't recreate root-level config files — add new tools as their own subdirectory.

## The nvim/ subtree

`nvim/` is a self-contained LazyVim configuration with **its own `nvim/CLAUDE.md`** — read that before touching anything under `nvim/`. In short: `stylua .` formats the Lua (config in `nvim/stylua.toml`), plugin specs live in `nvim/lua/plugins/*.lua` (auto-imported, override LazyVim defaults), and `nvim/lazy-lock.json` / `nvim/lazyvim.json` are committed and managed via `:Lazy sync` / `:LazyExtras`, not by hand.

## tmux + tmuxinator (the primary workflow)

These two are tightly coupled and are the most intricate part of the repo:

- `tmux/tmux.conf` — vi-style keybindings, mouse on, and a hand-built greyscale status bar with a single tokyonight-storm accent color (pick the accent in the `ACCENT` block near the top). The status bar's right side calls **`tmux/scripts/{cpu,mem,battery}.sh`** — small macOS-specific shell scripts (parsing `top`, `vm_stat`, `pmset`) that must remain executable and reachable at `~/.config/tmux/scripts/`. Several mouse bindings are deliberately rebound from `MouseDown*` to `MouseUp*`/`MouseDrag` to work around a Ghostty mouse-press forwarding bug — the inline comments explain why; don't "simplify" them back to the defaults.
- `tmuxinator/honey.yml` — the work session. Every repo window reuses **one raw tmux `window_layout` string** defined once as the `&repo_layout` YAML anchor and referenced via `*repo_layout`; retune pane sizes in that one place (regenerate the string with `tmux display-message -p '#{window_layout}'`). Each window's panes run `cd<repo> && nvim|clear|claude` — the `cdhc`, `cdhcw`, `cdsoc`, `cdhca`, `cdsf`, `cdem`, `cddotfiles`, `authqz` commands are **shell aliases defined outside this repo**, so they won't resolve from a bare shell.

## Theming note

There is no single shared theme: tmux uses tokyonight-storm accents, `starship.toml` uses a gruvbox palette, the terminals (`ghostty`, `alacritty`) carry a VS Code-dark ANSI palette ported from iTerm2, `yazi` defaults to tokyo-night (`yazi/theme.toml`, with flavors vendored under `yazi/flavors/` and pinned in `yazi/package.toml`), and `ccstatusline` overrides its widget foreground with a `gradient:retro` (per-widget ANSI colors set in `ccstatusline/settings.json`). Match the theme of the tool you're editing rather than assuming a repo-wide palette.
