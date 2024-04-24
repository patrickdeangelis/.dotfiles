vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use({ 'rose-pine/neovim', as = 'rose-pine' })

  use({ 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'} })
  use 'nvim-treesitter/playground'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'

  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  }
  use 'airblade/vim-gitgutter'
  use {
    "folke/todo-comments.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }
  use ({
      'ray-x/go.nvim',
      requires = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
  })
  use 'ray-x/guihua.lua'
  use 'github/copilot.vim'
  use 'mattn/vim-goimports'
  use 'gpanders/editorconfig.nvim'
  use {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
  }
end)
