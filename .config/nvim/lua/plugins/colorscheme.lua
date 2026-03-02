return {
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("plugins.colors.cherryblossom").setup()
    end,
  },
}
