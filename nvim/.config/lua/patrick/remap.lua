vim.g.mapleader = " "
vim.keymap.set("n","<leader>e", vim.cmd.Ex)

-- Moves the highlighted code block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--Allow search terms to keep in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- delete the element and sent to void register, so you don't lose the element that you're pasting
vim.keymap.set("x", "<leader>p", [["_dP]])

-- copy elements to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- paste from system clipboard
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]])
vim.keymap.set("n", "<leader>P", [["+P]])

-- delete to void register
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- open vim packer
vim.keymap.set("n", "<leader>vp", "<cmd>e ~/.config/nvim/lua/patrick/packer.lua<CR>");

-- source file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- fold code blocks
vim.api.nvim_set_keymap('n', 'zf', [[<Cmd>normal! Vzf<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'zo', [[<Cmd>normal! zo<CR>]], { noremap = true, silent = true })
