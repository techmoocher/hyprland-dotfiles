local M = {}

local c = {
  bg        = "#120A10",
  bg2       = "#1A0F18",
  bg3       = "#241422",

  fg        = "#F2E9EE",
  fg2       = "#D9C9D1",
  muted     = "#B9A2AE",

  pink      = "#FF8FC7",
  pink2     = "#FFB3D9",
  sakura    = "#FFA5D2",

  red       = "#FF5C7A",
  orange    = "#FFB86C",
  yellow    = "#FFD88A",
  green     = "#A6E3A1",
  cyan      = "#7DE5D4",
  blue      = "#89B4FA",
  purple    = "#CBA6F7",

  comment   = "#8E7A88",

  border    = "#3A2232",
  cursor    = "#FF8FC7",
  visual    = "#3B1C2C",

  none      = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.setup()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end

  vim.o.termguicolors = true
  vim.g.colors_name = "cherryblossom"

  -- Core UI
  hi("Normal",       { fg = c.fg, bg = c.bg })
  hi("NormalNC",     { fg = c.fg2, bg = c.bg })
  --hi("EndOfBuffer",  { fg = c.bg3 })
  hi("SignColumn",   { bg = c.bg })
  hi("FoldColumn",   { fg = c.muted, bg = c.bg })
  hi("Folded",       { fg = c.muted, bg = c.bg2 })

  hi("Cursor",       { fg = c.bg, bg = c.cursor })
  hi("CursorLine",   { bg = c.bg2 })
  hi("CursorColumn", { bg = c.bg2 })
  hi("ColorColumn",  { bg = c.bg2 })
  hi("LineNr",       { fg = c.comment })
  hi("CursorLineNr", { fg = c.sakura, bold = true })

  hi("Visual",       { bg = c.visual })
  hi("Search",       { fg = c.bg, bg = c.yellow, bold = true })
  hi("IncSearch",    { fg = c.bg, bg = c.orange, bold = true })
  hi("MatchParen",   { fg = c.pink2, bold = true })

  hi("Pmenu",        { fg = c.fg2, bg = c.bg2 })
  hi("PmenuSel",     { fg = c.bg, bg = c.sakura, bold = true })
  hi("PmenuSbar",    { bg = c.bg3 })
  hi("PmenuThumb",   { bg = c.border })

  hi("FloatBorder",  { fg = c.border, bg = c.bg2 })
  hi("NormalFloat",  { fg = c.fg2, bg = c.bg2 })
  hi("WinSeparator", { fg = c.border })

  hi("StatusLine",   { fg = c.fg2, bg = c.bg2 })
  hi("StatusLineNC", { fg = c.muted, bg = c.bg2 })

  hi("TabLine",      { fg = c.muted, bg = c.bg2 })
  hi("TabLineSel",   { fg = c.bg, bg = c.sakura, bold = true })
  hi("TabLineFill",  { bg = c.bg })

  -- Text
  hi("Comment",      { fg = c.comment, italic = true })
  hi("Constant",     { fg = c.pink2 })
  hi("String",       { fg = c.green })
  hi("Character",    { fg = c.green })
  hi("Number",       { fg = c.orange })
  hi("Boolean",      { fg = c.orange })
  hi("Float",        { fg = c.orange })

  hi("Identifier",   { fg = c.fg })
  hi("Function",     { fg = c.pink })

  hi("Statement",    { fg = c.purple })
  hi("Keyword",      { fg = c.purple, bold = true })
  hi("Operator",     { fg = c.fg2 })
  hi("PreProc",      { fg = c.cyan })
  hi("Type",         { fg = c.blue })
  hi("Special",      { fg = c.sakura })

  hi("Todo",         { fg = c.bg, bg = c.pink2, bold = true })

  -- Diagnostics
  hi("DiagnosticError", { fg = c.red })
  hi("DiagnosticWarn",  { fg = c.yellow })
  hi("DiagnosticInfo",  { fg = c.blue })
  hi("DiagnosticHint",  { fg = c.cyan })

  hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
  hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.yellow })
  hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.blue })
  hi("DiagnosticUnderlineHint",  { undercurl = true, sp = c.cyan })

  -- Git
  hi("DiffAdd",    { bg = "#15251A" })
  hi("DiffChange", { bg = "#1A2033" })
  hi("DiffDelete", { bg = "#2B121A" })
  hi("DiffText",   { bg = "#2A3150" })

  hi("GitSignsAdd",    { fg = c.green })
  hi("GitSignsChange", { fg = c.blue })
  hi("GitSignsDelete", { fg = c.red })

  -- Treesitter (fallback)
  hi("@comment", { link = "Comment" })
  hi("@string",  { link = "String" })
  hi("@number",  { link = "Number" })
  hi("@boolean", { link = "Boolean" })
  hi("@function", { link = "Function" })
  hi("@keyword", { link = "Keyword" })
  hi("@type",    { link = "Type" })
  hi("@variable", { fg = c.fg })
  hi("@property", { fg = c.fg2 })
  hi("@punctuation.delimiter", { fg = c.fg2 })
  hi("@punctuation.bracket",   { fg = c.fg2 })

  -- LSP
  hi("LspReferenceText",  { bg = c.bg3 })
  hi("LspReferenceRead",  { bg = c.bg3 })
  hi("LspReferenceWrite", { bg = c.bg3 })

  -- Telescope
  hi("TelescopeNormal",     { fg = c.fg2, bg = c.bg2 })
  hi("TelescopeBorder",     { fg = c.border, bg = c.bg2 })
  hi("TelescopePromptNormal",{ fg = c.fg, bg = c.bg3 })
  hi("TelescopePromptBorder",{ fg = c.border, bg = c.bg3 })
  hi("TelescopeSelection",  { bg = c.visual })
  hi("TelescopeMatching",   { fg = c.sakura, bold = true })

  -- NvimTree
  hi("NvimTreeNormal",      { fg = c.fg2, bg = c.bg })
  hi("NvimTreeFolderName",  { fg = c.blue })
  hi("NvimTreeOpenedFolderName", { fg = c.blue, bold = true })
  hi("NvimTreeRootFolder",  { fg = c.pink, bold = true })
end

return M
