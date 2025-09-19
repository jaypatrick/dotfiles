" ~/.vimrc - Vim configuration

" General settings
set nocompatible              " Disable vi compatibility
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set ruler                     " Show cursor position
set showcmd                   " Show command in status line
set showmatch                 " Highlight matching brackets
set incsearch                 " Incremental search
set hlsearch                  " Highlight search results
set ignorecase                " Case insensitive search
set smartcase                 " Smart case search
set autoindent                " Auto indent
set smartindent               " Smart indent
set expandtab                 " Use spaces instead of tabs
set tabstop=4                 " Tab width
set shiftwidth=4              " Indent width
set softtabstop=4             " Soft tab width
set wrap                      " Wrap lines
set linebreak                 " Break lines at word boundaries
set scrolloff=8               " Keep 8 lines above/below cursor
set sidescrolloff=8           " Keep 8 columns left/right of cursor
set mouse=a                   " Enable mouse support
set clipboard=unnamedplus     " Use system clipboard
set hidden                    " Allow hidden buffers
set encoding=utf-8            " Set encoding
set fileencoding=utf-8        " Set file encoding
set backspace=indent,eol,start " Better backspace behavior

" Visual settings
syntax enable                 " Enable syntax highlighting
set background=dark           " Dark background
set termguicolors             " True color support
set colorcolumn=80            " Show column at 80 characters
set cursorline                " Highlight current line
set wildmenu                  " Enhanced command completion
set wildmode=longest:full,full " Command completion mode

" File handling
set backup                    " Enable backups
set backupdir=~/.vim/backup// " Backup directory
set directory=~/.vim/swap//   " Swap directory
set undofile                  " Persistent undo
set undodir=~/.vim/undo//     " Undo directory

" Create directories if they don't exist
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p")
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p")
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p")
endif

" Key mappings
let mapleader = ","           " Set leader key

" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Toggle line numbers
nnoremap <leader>n :set relativenumber!<CR>

" File type specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Status line
set laststatus=2              " Always show status line
set statusline=%F%m%r%h%w\ [%l,%c]\ [%L]\ %p%%