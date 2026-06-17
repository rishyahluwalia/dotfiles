-- diffview.nvim: full-tab git diffs, file/branch history, and a 3-way
-- merge-conflict resolution UI.
--
-- Coexists with the existing git stack rather than replacing it:
--   * gitsigns -> inline hunk signs + <leader>gh* (stage/reset/preview)
--   * snacks   -> lazygit (<leader>gg) and git pickers
--   * diffview -> the conventional <leader>gd, below
--
-- This deliberately takes over <leader>gd / <leader>gD, which LazyVim's snacks
-- picker uses for its git-diff pickers. Those pickers are NOT lost: the keys
-- below free them from snacks and re-home them on <leader>gx / <leader>gX, and
-- they remain callable any time via `:lua Snacks.picker.git_diff()`.
return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    keys = {
      {
        "<leader>gd",
        function()
          -- Toggle: close if any diffview tab is open, otherwise open one.
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "Diffview (working tree)",
      },
      { "<leader>gD", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview file history (file)" },
      {
        "<leader>gm",
        function()
          -- Resolve the repo's default branch (main vs master) rather than
          -- hardcoding it, so this works across repos.
          local function default_branch()
            -- origin/HEAD points at the remote default branch when it's set.
            local head = vim.fn.systemlist({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })[1]
            if vim.v.shell_error == 0 and head then
              return (head:gsub("^origin/", ""))
            end
            -- Fallback: whichever of main/master exists locally.
            for _, b in ipairs({ "main", "master" }) do
              vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", b })
              if vim.v.shell_error == 0 then
                return b
              end
            end
            return "main"
          end
          vim.cmd("DiffviewOpen " .. default_branch() .. "...HEAD")
        end,
        desc = "Diff vs default branch",
      },
    },
    opts = {
      enhanced_diff_hl = true,
      file_panel = {
        listing_style = "list", -- default is "tree"
        win_config = {
          width = 50, -- default is 35; list view shows full paths, so a touch wider
        },
      },
      -- During a merge conflict, <leader>gd shows OURS | result | THEIRS so you
      -- can resolve in-place; this picks that 3-way layout.
      view = {
        merge_tool = { layout = "diff3_mixed" },
      },
    },
  },

  -- Free <leader>gd / <leader>gD from the snacks git-diff pickers (so diffview
  -- can own them) and re-home those pickers on <leader>gx / <leader>gX.
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gd", false },
      { "<leader>gD", false },
      -- stylua: ignore
      { "<leader>gx", function() Snacks.picker.git_diff() end, desc = "Git Diff Picker (hunks)" },
      -- stylua: ignore
      { "<leader>gX", function() Snacks.picker.git_diff({ base = "origin", group = true }) end, desc = "Git Diff Picker (origin)" },
    },
  },
}
