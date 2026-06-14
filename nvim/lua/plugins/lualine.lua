-- lualine.nvim: replace the default clock (os.date "%R") in the bottom-right
-- lualine_z corner with the current buffer's total line count. Overriding only
-- lualine_z keeps the section populated, so the accent color / gradient running
-- lualine_y (progress % + line:col) -> lualine_z is preserved.
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_z = {
        function()
          return "☰ " .. vim.api.nvim_buf_line_count(0)
        end,
      }
    end,
  },
}
