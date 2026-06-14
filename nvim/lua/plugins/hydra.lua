-- hydra.nvim: a "resize mode" sticky submenu for window splits. Press <C-w>r to
-- enter, then repeat h/j/k/l to resize the current split without re-pressing the
-- prefix; = equalizes, q/<Esc> exits. The h/l heads are edge-aware (resize_left/
-- resize_right): a split always grows toward its neighbour regardless of whether
-- it's the left- or right-most window, so the direction feels natural everywhere.
return {
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
