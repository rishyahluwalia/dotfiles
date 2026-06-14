-- snacks.nvim: LazyVim's all-in-one UI/utility suite. Customizations here:
--   * scroll   - smooth-scroll disabled.
--   * picker   - filename-first results; extra input keymaps (preview scroll
--                <C-d>/<C-u>, toggle ignored/hidden <S-i>/<S-h>, toggle test
--                files <C-t>, open in left/right split <C-h>/<C-l>); custom
--                actions backing those keymaps; wider explorer (50 cols); grep
--                with no default excludes.
--   * indent   - scope guide drawn in the Comment highlight; animation off.
return {
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
}
