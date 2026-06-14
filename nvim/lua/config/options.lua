-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Project root for LazyVim pickers / grep / explorer (this is LazyVim's `root`,
-- NOT the LSP server's own root_dir and NOT Vim's :cd — neither of those
-- actually changes here). LazyVim's default is { "lsp", { ".git", "lua" }, "cwd" }.
-- This dotfiles repo is a trap for it: `.git` is at the top level, but nvim/ has
-- both a `lua/` dir and a stylua.toml, so lua_ls roots itself at nvim/ AND the
-- `lua` marker resolves to nvim/ — both beat the top-level .git. The dashboard
-- has no file so root falls back to cwd (works), then the moment you open a Lua
-- file the root snaps to nvim/ and pickers scope there. Pinning to the git root
-- (then cwd as a fallback outside git) keeps everything at the repo level.
vim.g.root_spec = { ".git", "cwd" }

-- Formatting: we enable BOTH the biome and prettier extras. To stop them
-- fighting over JS/TS/JSON, require a Prettier config file before Prettier runs.
-- Result (per-repo, automatic):
--   * biome-check runs only where a biome.json exists (it already requires that).
--   * prettier  runs only where a .prettierrc / prettier config exists.
-- So honeycomb (biome.json) -> biome, honeycomb-web (.prettierrc) -> prettier.
vim.g.lazyvim_prettier_needs_config = true

-- Salesforce Apex: Neovim has no built-in filetype for these, so map them.
-- (.cls is also LaTeX class files, but this config has no LaTeX, and in the
-- salesforce repo every .cls is Apex.) Formatting is wired in plugins.lua.
vim.filetype.add({
  extension = {
    cls = "apex",
    trigger = "apex",
    apex = "apex",
  },
})
