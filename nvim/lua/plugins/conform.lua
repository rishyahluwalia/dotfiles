-- conform.nvim: code formatting. Builds on the LazyVim biome + prettier extras
-- with two project-specific rules:
--   1. For filetypes BOTH biome and prettier can format, run only the first
--      formatter whose config file is present (biome first). This stops repos
--      that have both a biome.json and a prettier config (e.g. emails) from
--      double-formatting. Single-config repos are unaffected — the non-matching
--      formatter is skipped by its own config check, so conform falls through to
--      the one that applies.
--   2. Salesforce Apex (.cls/.trigger/.apex) formats via the project's local
--      prettier + prettier-plugin-apex, through a dedicated `apex_prettier`
--      formatter that bypasses LazyVim's prettier parser-gate (which reports no
--      parser for .cls and would otherwise skip formatting).
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs({
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "jsonc",
        "css",
        "scss",
        "graphql",
        "vue",
      }) do
        opts.formatters_by_ft[ft] = { "biome-check", "prettier", stop_after_first = true }
      end

      local util = require("conform.util")
      opts.formatters = opts.formatters or {}
      opts.formatters.apex_prettier = {
        command = util.from_node_modules("prettier"),
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
        cwd = util.root_file({
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.js",
          "prettier.config.js",
          "package.json",
        }),
        require_cwd = true,
      }
      opts.formatters_by_ft.apex = { "apex_prettier" }
    end,
  },
}
