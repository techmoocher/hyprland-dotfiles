local M = {}

M.colors = {
  bg       = "#202328",
  fg       = "#bbc2cf",
  yellow   = "#ECBE7B",
  blue     = "#51afef",
  green    = "#98be65",
  magenta  = "#c678dd",
  red      = "#ec5f67",
}

M.mode_colors = {
  n = M.colors.blue,
  i = M.colors.green,
  v = M.colors.magenta,
  c = M.colors.red,
  t = M.colors.red,
}

return M
