local C = require("plugins.ui.lualine.colors")
local M = {}

M.mode_indicator = {
  function() return "▊" end,
  color = function() return { fg = C.mode_colors[vim.fn.mode()] } end,
  padding = { left = 0, right = 1 },
}

M.branch = {
  "branch",
  icon = "",
  color = { fg = C.colors.yellow, gui = "bold" },
}

M.diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    error = { fg = C.colors.red },
    warn = { fg = C.colors.yellow },
    info = { fg = C.colors.blue },
  },
}

return M
