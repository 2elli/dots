""" .nvimrc, neovim config file 2elli 
set nu
set tabstop=4
set expandtab
set shiftwidth=4
set tabstop=4

set autoindent
set copyindent  
set clipboard+=unnamedplus

set scrolloff=8

" keybinds
nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" search options
set ignorecase

" mapleader
nnoremap <SPACE> <Nop>
let mapleader=" "
" leader actions
nnoremap <leader>w :w<cr>
