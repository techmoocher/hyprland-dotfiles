local M = {}

function M.ins_left(tbl, component)
  table.insert(tbl.sections.lualine_c, component)
end

function M.ins_right(tbl, component)
  table.insert(tbl.sections.lualine_x, component)
end

return M
