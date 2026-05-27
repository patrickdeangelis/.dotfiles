return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "editorconfig/editorconfig-vim",
    event = "BufReadPre",
  },
  {
    "antonk52/denty.nvim",
    event = "BufReadPre",
    config = function()
      require("denty").setup({})
    end,
  },
  {
    "sotte/presenting.nvim",
    cmd = { "Presenting" },
    opts = {},
  },
}
