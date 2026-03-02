local C = require("plugins.ui.lualine.colors")
local U = require("plugins.ui.lualine.utils")
local components = require("plugins.ui.lualine.components")

local M = {}

function M.setup()
  local config = {
    options = {
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }

  -- Build sections programmatically
  U.ins_left(config, components.mode_indicator)
  U.ins_left(config, components.branch)
  U.ins_left(config, components.diagnostics)

  U.ins_right(config, { "encoding" })
  U.ins_right(config, { "filetype" })
  U.ins_right(config, { "progress" })
  U.ins_right(config, { "location" })

  require("lualine").setup(config)
end

return M
