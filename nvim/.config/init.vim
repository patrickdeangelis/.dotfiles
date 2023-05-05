call plug#begin()
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'APZelos/blamer.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'neovim/nvim-lspconfig' 
Plug 'nvim-lua/completion-nvim' 
Plug 'airblade/vim-gitgutter'
Plug 'haya14busa/is.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'eslint/eslint'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Plug 'dracula/vim', { 'name': 'dracula' }
Plug 'jaredgorski/spacecamp'
Plug 'christophermca/meta5'
Plug 'doums/darcula'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

let mapleader=" "
let g:blamer_enabled = 1

" Disable numbers at terminal
autocmd TermOpen * setlocal nonumber norelativenumber
" HTML highlight for .ejs
au BufNewFile,BufRead *.ejs set filetype=html

if(has("termguicolors"))
	set termguicolors
endif

nmap <leader>ve :edit ~/.config/nvim/init.vim<cr>

syntax enable
set guifont=DroidSansMono\ Nerd\ Font\ 11
set autoread
set number
set relativenumber
set tabstop=4 
set softtabstop=4
set shiftwidth=4
set hidden "" set expandtab
set smartindent
set nowrap
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
" set nohlsearch
set scrolloff=8
set inccommand=split
set colorcolumn=80
set signcolumn=yes
set background=dark
set diffopt+=vertical
set list
set listchars=tab:▸\ ,trail:·
" Update to make git gutter faster
set updatetime=100
" Single status line
set laststatus=3

" Grubbox theme
colorscheme gruvbox 

" colorscheme dracula


" transparent background
hi Normal guibg=NONE ctermbg=NONE

map <C-b> :NERDTreeToggle<CR>
map <C-e> :Ex<CR>
nnoremap <silent> <leader>h :wincmd h <CR>
nnoremap <silent> <leader>j :wincmd j <CR>
nnoremap <silent> <leader>k :wincmd k <CR>
nnoremap <silent> <leader>l :wincmd l <CR>
nnoremap <silent> <leader>t :wincmd n <bar> :wincmd J <bar> :resize 10 <bar> :set wfh <bar> :terminal<CR>
nnoremap <silent> <leader>pv :wincmd v <bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <silent> <C-n> :tabnew <CR>

" FZF key remap
" find files
nnoremap <silent> <C-f> :Files<CR>
" Find in files
nnoremap <silent> <Leader>f :Rg<CR>

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <M-[> <Esc>
  tnoremap <C-v><Esc> <Esc>
  tnoremap <leader><Esc> <Esc>
endif

" Global copy/paste binding
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" Gruvbox theme
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = '0'

" Gitgutter
let g:gitgutter_set_sign_backgrounds = 0
let g:gitgutter_sign_removed = '-'
highlight GitGutterAdd	  guibg=#aeb126	ctermbg=2 guifg=#2d2910 ctermfg=2
highlight GitGutterChange guibg=#84b972 ctermbg=3 guifg=#2d2910 ctermfg=3
highlight GitGutterDelete guibg=#ff2222 ctermbg=1 guifg=#2d2910 ctermfg=1

" FZF
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'down': '10' }

" Airline
set ttimeoutlen=50
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"


" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" LSP ---------------------------------------
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list=['exact', 'substring', 'fuzzy']
" CoC ------------------------------------------------------------------
set shortmess+=c
inoremap <silent><expr> <c-space> coc#refresh()
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use tab to navigate on sugestions
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
