-- Disable sign backgrounds for GitGutter
vim.g.gitgutter_set_sign_backgrounds = 0

-- Set sign characters for GitGutter
vim.g.gitgutter_sign_removed = '-'

-- Highlight colors for GitGutter signs
vim.cmd('highlight GitGutterAdd guibg=#aeb126 ctermbg=2 guifg=#2d2910 ctermfg=2')
vim.cmd('highlight GitGutterChange guibg=#84b972 ctermbg=3 guifg=#2d2910 ctermfg=3')
vim.cmd('highlight GitGutterDelete guibg=#ff2222 ctermbg=1 guifg=#2d2910 ctermfg=1')
