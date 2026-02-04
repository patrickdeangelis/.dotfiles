vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
vim.g.db_ui_show_help = 0

vim.keymap.set("n", "<leader>db", "<cmd>DBUI<CR>")
vim.keymap.set("n", "<leader>dt", "<cmd>DBUIToggle<CR>")
vim.keymap.set("n", "<leader>da", "<cmd>DBUIAddConnection<CR>")
