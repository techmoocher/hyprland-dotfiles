local g = vim.g
local api = vim.api
local lsp = vim.lsp
local opt = vim.opt


--- ### APPEARANCE ### ---
opt.termguicolors = true
opt.wrap = true
opt.signcolumn = "yes:2"
opt.scrolloff = 8
opt.number = true
opt.relativenumber = true
opt.cursorline = true

api.nvim_set_hl(0, "LineNr",        { fg = "#d7b2c6" })
--api.nvim_set_hl(0, "LineNr",        { fg = "#caa3b8" })
api.nvim_set_hl(0, "LineNrAbove",   { fg = "#ffe6f2" })
api.nvim_set_hl(0, "LineNrBelow",   { fg = "#ffd6eb" })
api.nvim_set_hl(0, "CursorLineNr",  { fg = "#ff69be", bold = true })
--api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff69be", bold = true })
--api.nvim_set_hl(0, "LineNrAbove", { fg = "#ffd6eb" })


--- ### IDENTATION ### ---
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

opt.smartindent = true
opt.autoindent = true
opt.backspace = { "indent", "eol", "start" }


--- ### WHITESPACES & CHARACTERS ### ---
opt.list = true
opt.listchars = {
  trail = "·",
  nbsp = "◇",
  tab = "→ ",
  extends = "▸",
  precedes = "◂"
}


--- ### EDIT EXPERIENCE ### ---
opt.clipboard = "unnamedplus"
opt.history = 100
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.splitkeep = "screen"
opt.splitright = true
opt.splitbelow = true

opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.autoread = true 

opt.smoothscroll = true
opt.endofline = false


--- ### PERFORMANCE ### ---
opt.diffopt:append("linematch:60")

opt.timeoutlen = 500
opt.updatetime = 200
opt.lazyredraw = true


--- ### LEADER KEYS ### ---
g.mapleader = " "
g.maplocalleader = " "

--- ### LSP ### ---
lsp.enable("jdtls")
