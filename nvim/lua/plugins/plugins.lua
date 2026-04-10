-- since this is just an example spec, don't actually load anything here and return an empty spec
if true then
  return {
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
    { "olimorris/onedarkpro.nvim" },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "tokyonight",
      },
    },
    {
      "folke/snacks.nvim",
      opts = {
        scroll = { enabled = false },
        picker = {
          formatters = {
            file = {
              filename_first = true,
            },
          },
          layout = {
            -- reverse = true,
            -- preset = "telescope", -- ivy layout has input at bottom
          },
          win = {
            input = {
              keys = {
                ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<S-i>"] = { "toggle_ignored", mode = { "n" } },
                ["<S-h>"] = { "toggle_hidden", mode = { "n" } },
                ["<C-t>"] = { "toggle_test_files", mode = { "i", "n" }, desc = "Toggle test files" },
                ["<C-l>"] = { "open_right", mode = { "i", "n" } },
                ["<C-h>"] = { "open_left", mode = { "i", "n" } },
                -- ["<A-l>"] = { "inspect", mode = { "i", "n" } },
                -- ["<A-l>"] = {
                --   function(picker, item)
                --     if item then
                --       picker:close()
                --       vim.cmd("wincmd l")
                --       vim.cmd("edit " .. item.file)
                --     end
                --   end,
                --   mode = { "i", "n" },
                --   desc = "Open in right split",
                -- },
                -- ["<A-h>"] = {
                --   function(picker, item)
                --     if item then
                --       picker:close()
                --       vim.cmd("wincmd h")
                --       vim.cmd("edit " .. item.file)
                --     end
                --   end,
                --   mode = { "i", "n" },
                --   desc = "Open in left split",
                -- },
                -- ["<Tab>"] = { "select", mode = { "i", "n" } },
              },
            },
          },
          actions = {
            open_right = function(picker, item)
              if item then
                picker:close()
                vim.cmd("wincmd l")
                vim.cmd("edit " .. item.file)
              end
            end,
            open_left = function(picker, item)
              if item then
                picker:close()
                vim.cmd("wincmd h")
                vim.cmd("edit " .. item.file)
              end
            end,
            toggle_test_files = function(picker)
              if picker._hide_tests then
                picker._hide_tests = false
                picker.opts.transform = picker._original_transform
              else
                picker._hide_tests = true
                picker._original_transform = picker.opts.transform
                picker.opts.transform = function(item)
                  local file = item.file or item.text or ""
                  if file:match("%.test%.") or file:match("%.spec%.") or file:match("__tests__/") then
                    return false
                  end
                  return item
                end
              end
              picker:find()
            end,
            -- toggle_test_files = function(picker)
            --   local excludes = picker.opts.exclude or {}
            --   if #excludes > 0 then
            --     picker.opts.exclude = {}
            --   else
            --     picker.opts.exclude = { "*.test.*", "*.spec.*", "__tests__/*" }
            --   end
            --   picker:find()
            -- end,
          },
          sources = {
            explorer = {
              layout = {
                layout = {
                  width = 50,
                },
              },
            },
            grep = {
              exclude = {}, -- start with no excludes
              -- win = {
              --   input = {
              --     keys = {
              --       ["<C-t>"] = { "toggle_test_files", mode = { "i", "n" }, desc = "Toggle test files" },
              --     },
              --   },
              -- },
            },
            files = {},
            -- lsp_references = {
            --   win = {
            --     input = {
            --       keys = {
            --         ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            --         ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            --       },
            --     },
            --   },
            -- },
          },
        },
        indent = {
          scope = {
            hl = "Comment",
          },
          animate = {
            enabled = false,
          },
        },
      },
    },
    {
      "neovim/nvim-lspconfig",
      opts = {
        diagnostics = {
          virtual_text = {
            severity = { min = vim.diagnostic.severity.WARN },
          },
        },
      },
    },
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
    {
      "nvimtools/hydra.nvim",
      lazy = false,
      config = function()
        local Hydra = require("hydra")

        local function resize_left()
          local win = vim.api.nvim_get_current_win()
          local wins = vim.api.nvim_tabpage_list_wins(0)
          local pos = vim.api.nvim_win_get_position(win)
          local is_leftmost = true
          for _, w in ipairs(wins) do
            local p = vim.api.nvim_win_get_position(w)
            if p[2] < pos[2] then
              is_leftmost = false
              break
            end
          end
          if is_leftmost then
            vim.cmd("vertical resize -5")
          else
            vim.cmd("vertical resize +5")
          end
        end

        local function resize_right()
          local win = vim.api.nvim_get_current_win()
          local wins = vim.api.nvim_tabpage_list_wins(0)
          local pos = vim.api.nvim_win_get_position(win)
          local is_leftmost = true
          for _, w in ipairs(wins) do
            local p = vim.api.nvim_win_get_position(w)
            if p[2] < pos[2] then
              is_leftmost = false
              break
            end
          end
          if is_leftmost then
            vim.cmd("vertical resize +5")
          else
            vim.cmd("vertical resize -5")
          end
        end

        local resize = Hydra({
          name = "Resize",
          mode = "n",
          body = "<C-w>r",
          heads = {
            { "h", resize_left, { desc = "←" } },
            { "l", resize_right, { desc = "→" } },
            { "j", "5<C-w>-", { desc = "↓" } },
            { "k", "5<C-w>+", { desc = "↑" } },
            { "=", "<C-w>=", { desc = "equal" } },
            { "q", nil, { exit = true, desc = "quit" } },
            { "<Esc>", nil, { exit = true } },
          },
        })

        vim.keymap.set("n", "<C-w>r", function()
          resize:activate()
        end, { desc = "Resize mode" })
      end,
    },
  }
end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/trouble.nvim", enabled = false },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },

  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
