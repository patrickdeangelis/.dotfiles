return {
  { "rose-pine/neovim", name = "rose-pine" },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    config = function()
      vim.o.background = "light"
    end,
  },
  { "oxfist/night-owl.nvim", name = "night-owl" },
  { "nickkadutskyi/jb.nvim", name = "jb" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
