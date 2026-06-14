-- Lean plugin overrides. Chunkier specs live in their own files under
-- lua/plugins/ (conform.lua, snacks.lua, hydra.lua, diffview.lua) — lazy.nvim
-- auto-imports every file here, so splitting is purely organizational.
return {
  -- blink.cmp: completion engine. Remap so <C-j>/<C-k> cycle the menu and
  -- <Tab> accepts the selection (falling back to normal behavior otherwise).
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "accept", "fallback" },
      })
    end,
  },

  -- onedarkpro.nvim: alternative colorscheme; installed but not active
  -- (tokyonight is set below). Switch any time with :colorscheme onedark*.
  { "olimorris/onedarkpro.nvim" },

  -- LazyVim core: set the active colorscheme.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- tokyonight: tame the diffview diff-filler diagonals. The ╱ placeholder rows
  -- (where one side has extra lines) are drawn with DiffviewDiffDeleteDim, which
  -- defaults to Comment (too light) — recolour them to a dark, near-background
  -- grey so the diagonals recede. We deliberately leave DiffDelete alone:
  -- diffview derives the removed-line highlight (DiffviewDiffAddAsDelete) from
  -- it, so the default keeps removed lines red-backed with readable, syntax-
  -- coloured text (setting DiffDelete's fg would grey that text out). Want the
  -- diagonals even fainter? c.fg_gutter -> c.bg_highlight.
  {
    "folke/tokyonight.nvim",
    opts = {
      -- Transparency (disabled). Uncomment to defer the background to Ghostty so
      -- Neovim inherits the terminal's opacity + blur (Ghostty:
      -- background-opacity=0.9, background-blur=20). Neovim has no opacity/blur
      -- knob of its own — terminals draw cells with an explicit bg colour
      -- opaquely, so the only way to reveal the terminal's transparency is to NOT
      -- set a bg. transparent=true sets Normal/NormalNC/SignColumn bg to NONE;
      -- the styles extend that to sidebars (neo-tree, etc.) and floats. It always
      -- matches Ghostty automatically — no values to copy. If completion/hover
      -- floats end up hard to read, set floats = "dark" instead.
      -- transparent = true,
      -- styles = {
      --   sidebars = "transparent",
      --   floats = "transparent",
      -- },
      on_highlights = function(hl, c)
        hl.DiffviewDiffDeleteDim = { fg = c.fg_gutter, bg = "NONE" }
      end,
    },
  },

  -- nvim-lspconfig: only render inline (virtual text) diagnostics for WARN and
  -- above, keeping INFO/HINT noise out of the line. Signs/underlines still show
  -- all severities.
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = {
          severity = { min = vim.diagnostic.severity.WARN },
        },
      },
      -- Disable LSP inlay hints (the inferred ": boolean" / param-name virtual
      -- text vtsls injects). LazyVim defaults this to true. Runtime toggle is
      -- still <leader>uh if you want them back temporarily.
      --
      -- Prefer keeping param-name hints but dropping the noisy TYPE hints?
      -- Remove this line and instead override the vtsls server settings:
      --   servers.vtsls.settings.typescript.inlayHints = {
      --     functionLikeReturnTypes = { enabled = false },
      --     parameterTypes          = { enabled = false },
      --     propertyDeclarationTypes = { enabled = false },
      --   }
      inlay_hints = { enabled = false },
      servers = {
        -- yamlls: teach yaml-language-server CloudFormation's intrinsic-function
        -- short tags so they stop showing up as "Unresolved tag: !Ref". This is
        -- purely additive tolerance — it does NOT give CFN-aware validation (for
        -- that you'd add cfn-lint via nvim-lint). The " scalar"/" sequence"/
        -- " mapping" suffix declares which node kind each tag wraps; tags that
        -- accept multiple forms (e.g. !Sub, !GetAtt) are listed once per kind.
        yamlls = {
          settings = {
            yaml = {
              customTags = {
                "!Ref scalar",
                "!Sub scalar",
                "!Sub sequence",
                "!GetAtt scalar",
                "!GetAtt sequence",
                "!GetAZs scalar",
                "!ImportValue scalar",
                "!ImportValue mapping",
                "!Join sequence",
                "!Select sequence",
                "!Split sequence",
                "!FindInMap sequence",
                "!Base64 scalar",
                "!Base64 mapping",
                "!Cidr sequence",
                "!Transform mapping",
                "!Condition scalar",
                "!If sequence",
                "!Equals sequence",
                "!And sequence",
                "!Or sequence",
                "!Not sequence",
              },
            },
          },
        },
      },
    },
  },

  -- claudecode.nvim: in-editor Claude Code integration. Disabled — Claude runs
  -- in a dedicated tmux pane instead. Uncomment to use the Neovim integration.
  -- {
  --   "coder/claudecode.nvim",
  --   dependencies = { "folke/snacks.nvim" },
  --   config = true,
  --   keys = {
  --     { "<leader>a", nil, desc = "AI/Claude Code" },
  --     { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
  --     { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
  --     { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
  --     { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
  --     { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
  --     { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
  --     { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  --     {
  --       "<leader>as",
  --       "<cmd>ClaudeCodeTreeAdd<cr>",
  --       desc = "Add file",
  --       ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
  --     },
  --     -- Diff management
  --     { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
  --     { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  --   },
  -- },
}
