return {
  -- themes
  { "ellisonleao/gruvbox.nvim", name = "gruvbox" },
  { "oxfist/night-owl.nvim", name = "night-owl" },
  { "nickkadutskyi/jb.nvim", name = "jb" },

  -- Configure LazyVim to load night-owl
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "night-owl",
    },
  },
}
