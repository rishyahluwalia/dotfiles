# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim configuration built on [LazyVim](https://github.com/LazyVim/LazyVim) (a Neovim distro that is itself a lazy.nvim plugin). It lives at `~/.config/nvim`. There is no build/test suite — changes are validated by running Neovim.

## Load flow

`init.lua` → `require("config.lazy")` → bootstraps `lazy.nvim`, then `require("lazy").setup` with this spec order (`lua/config/lazy.lua`):

1. `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }` — pulls in the entire LazyVim distro and its default plugin specs.
2. `{ import = "plugins" }` — imports every file under `lua/plugins/`, which **overrides/extends** the LazyVim defaults.

LazyVim auto-loads three config files (do not `require` them yourself):

- `lua/config/options.lua` — loaded **before** startup. Extends LazyVim's option defaults.
- `lua/config/keymaps.lua` — loaded on `VeryLazy`. Extends LazyVim's default keymaps.
- `lua/config/autocmds.lua` — loaded on `VeryLazy`. Remove a LazyVim default autocmd via `vim.api.nvim_del_augroup_by_name("lazyvim_<name>")`.

`lazyvim.json` records enabled LazyVim **extras** (currently `coding.mini-surround`, `formatting.biome`, `formatting.prettier`, `lang.java`, `lang.kotlin`, `lang.python`, `lang.typescript`, `linting.eslint`); manage these with `:LazyExtras`, not by hand-editing. `lazy-lock.json` pins every plugin commit and is committed — update it with `:Lazy sync`/`:Lazy update`.

## Editing plugins

Every file under `lua/plugins/` is auto-imported by lazy.nvim and returns a spec (or list of specs). Current layout:

- `plugins.lua` — lean, one-off overrides only (blink.cmp keymaps, active colorscheme, lspconfig diagnostics).
- `conform.lua` — formatting: biome↔prettier precedence and the Salesforce Apex formatter.
- `snacks.lua` — snacks picker / indent / UI customization.
- `hydra.lua` — the `<C-w>r` window-resize submenu.
- `diffview.lua` — git diff / file-history / merge-conflict UI.

Put chunky specs in their own file; keep small overrides in `plugins.lua`.

> Historical note: `plugins.lua` used to wrap its active spec in an `if true then return {…} end` guard, with the LazyVim starter template's unreachable example spec (gruvbox, `tsserver`/typescript.nvim, etc.) sitting below it as dead code. That guard and the dead block have been removed — the file is now a plain `return {…}`.

Each spec is `{ "owner/repo", opts = {…} }`. Use `opts = function(_, opts) … end` to **extend** a list (e.g. `vim.list_extend(opts.ensure_installed, {…})`) since `opts` tables are deep-merged but lists get overwritten. Disable a default plugin with `{ "owner/repo", enabled = false }`.

## Commands

- Format Lua: `stylua .` — config in `stylua.toml` (2-space indent, 120-column width). `stylua` is installed via Mason (`:Mason`).
- Formatting runs through `conform.nvim` (configured in `lua/plugins/conform.lua`): per-repo biome↔prettier selection, plus Salesforce Apex via prettier-plugin-apex.
- Sync/update plugins headless: `nvim --headless "+Lazy! sync" +qa`.
- Diagnose setup: `nvim "+checkhealth"` (or `:LazyHealth`, `:checkhealth lazyvim`).
- Mason installs tools from LazyVim defaults (`stylua`, `shfmt`) and the enabled extras (`prettier`, `biome`, `ruff`, `ktlint`, `jdtls`, `vtsls`, …); there is no custom `ensure_installed` list anymore.

## Conventions

- Commit messages follow Conventional Commits (`fix:`, `docs:`, …), per git history.
- `.neoconf.json` enables `neodev`/`neoconf` so `lua_ls` resolves the Neovim and plugin Lua APIs while editing this config.
