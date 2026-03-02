vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.opt.fillchars = { eob = '~' }
    vim.cmd("highlight EndOfBuffer guifg=#af9eaa")
  end,
})
