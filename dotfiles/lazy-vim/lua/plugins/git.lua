return {
  "mbbill/undotree",
  "tpope/vim-fugitive",
  "airblade/vim-gitgutter",
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
        virt_text_pos = "eol",
      },
    },
  },
}
