-- Set timeout for key mapping
vim.o.ttimeoutlen = 50

-- Airline configuration
vim.g['airline#extensions#hunks#enabled'] = 0
vim.g['airline#extensions#branch#enabled'] = 1
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#formatter'] = 'default'

-- Airline symbols
if not vim.g.airline_symbols then
    vim.g.airline_symbols = {}
end

-- vim.g.airline_symbols.space = '\ua0'

