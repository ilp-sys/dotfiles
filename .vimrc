call plug#begin('~/.vim/plugged')
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'pbondoer/vim-42header'
Plug 'neovim/nvim-lspconfig'
call plug#end()

if has("syntax")
	syntax on
endif

set nu
set autoindent
set smartindent
set cindent

set shiftwidth=4
set tabstop=4
set ignorecase
set hlsearch
set showmatch
set cursorline
set laststatus=2

set ruler
set title

set mouse=a

" Enable copy to clipboard
set clipboard=unnamed

set lcs=tab:\|\ 

color default
