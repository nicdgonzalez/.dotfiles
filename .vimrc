" __   _____ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
" (_)_/ |_|_| |_| |_|_|  \___|
"
" Author: Nicolas Gonzalez <ndgfrs@gmail.com>
"
" Feel free to use this file as a starting point or peek at it for ideas.
" Don't just copy-paste it! Vim is all about making it *your* own editor.
"
" If you want to try out this setup, run the following commands:
"
"   git clone https://github.com/nicdgonzalez/.dotfiles && cd .dotfiles
"   vim -u ./.vimrc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{

" Ditch Vi defaults so Vim can behave in a more useful way.
set nocompatible

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"
" Plugin Manager: https://github.com/junegunn/vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{

call plug#begin()  " Defaults to '~/.vim/plugged'

" The package manager can manage itself.
Plug 'junegunn/vim-plug'

" Language-Server-Protocol-related plugins
" {{{

" Async LSP support for Vim
Plug 'prabirshrestha/vim-lsp'

" For displaying auto-complete popups.
Plug 'prabirshrestha/asyncomplete.vim'

" Enhances auto-completion capabilities for Language Servers
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Auto-configurations for Language Servers.
Plug 'mattn/vim-lsp-settings'

" }}}

" Display which function you're in, even when the signature goes out of view.
Plug 'wellle/context.vim'

" Syntax highlighting and indentation for Svelte components.
Plug 'evanleck/vim-svelte'
            \ | Plug 'othree/html5.vim'
            \ | Plug 'pangloss/vim-javascript'

call plug#end()

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{

if &t_Co == 256
    " Allow Vim to use 12-bit colors
    set termguicolors
endif

" Enable syntax highlighting
syntax on

try
    colorscheme ndg
catch
    " If the color scheme is not available, fallback to Vim's default.
endtry

" Mark the nth vertical column (80 is the standard for most coding styles)
set colorcolumn=80

" Set the height of the command-line. Larger values are useful for avoiding
" 'Press <ENTER> to continue'-like messages (i.e. there isn't enough space
" to display all of the text)
set cmdheight=2

" Displays the cursor's position in the bottom right corner
set ruler

" Show line numbers on the left
set number

" The numbers directly above/below the cursor line start at 1. This is
" useful for moving around using Vim motions (e.g. 5j to go down 5 lines)
set relativenumber

" Set the minimum width of the line-numbers column
set numberwidth=1

" Add padding to the left of the line numbers
set foldcolumn=1

" Show the current mode by the command-line
set showmode

" Whether to highlight search results.
set nohlsearch

" When searching, show matches as you type.
set incsearch

" Whether to ignore case when searching.
set ignorecase
set smartcase

" Use the '/g' flag by default when using search and replace
set gdefault

" Keep at least n lines above and below the cursor when scrolling
set scrolloff=8

" Do not redraw while executing macros
set lazyredraw

" Enable mouse support
set mouse=a

" Determine how folds are generated.
set foldmethod=marker

" Automatically save folds as-is when closing a file.
autocmd BufWinLeave * silent! mkview

" Automatically load the saved folds when opening a file.
autocmd BufWinEnter * silent! loadview

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backup and Swap files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{

" For me, these get in the way more than they are helpful.
set nobackup
set noswapfile

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text, tabs, and indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{

" Configure the backspace key to work as expected.
set backspace=indent,eol,start

" Enable the system clipboard.
" Warning: Vim must be compiled with `+clipboard` (see `:version`).
set clipboard^=unnamed,unnamedplus

" Use spaces instead of tabs
set expandtab

" Set the number of spaces a <Tab> in the file is worth.
set tabstop=8

" Set the number of spaces that a tab in the file is worth when editing.
set softtabstop=4

" Set the number of spaces a level of indentation is worth.
set shiftwidth=4

" A smarter version of `autoindent` that understands basic C-style syntax.
set smartindent

" Set the maximum width before Vim attempts to automatically break.
set textwidth=0

" Whether or not to (visually) break lines at word boundaries.
set nowrap

" Highlight matching brackets when the cursor is over one.
set showmatch

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{

" By default, mapleader is '\' (the most popular alternative is ',').
let mapleader = " "

" Paste the current date and time.
nmap <leader>dt "=strftime('%Y-%m-%d %H:%M%z')<cr>p

" Return the display to the last file explorer window.
map <leader>pv :Explore<cr>

" Split the display vertically and open the file explorer to the left.
map <C-b> :Sexplore!<cr>

" A better way to switch between active windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Move a line of text up or down. (This also helps new Vim users break
" the habit of using arrow keys :)
map <down> :m .+1<cr>==
map <up> :m .-2<cr>==

imap <down> <esc>:m .+1<cr>==gi
imap <up> <esc>:m .-2<cr>==gi

vmap <down> :m '>+1<cr>gv=gv
vmap <up> :m '<-2<cr>gv=gv

" Switch the CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Return to the last edited line when opening a file. (You want this!)
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$")
            \ | exe "normal! g'\""
            \ | endif

function! StripTrailingSpaces()
    let l:save_cursor = getpos(".")
    let l:old_query = getreg("/")
    silent! %s/\s\+$//e
    call setpos(".", l:save_cursor)
    call setreg("/", l:old_query)
endfunction

" Clean up trailing whitespaces on save.
autocmd BufWritePre * :call StripTrailingSpaces()

" Automatically resize splits when resizing the terminal window.
autocmd VimResized * wincmd =

" Automatically complete brackets, parentheses, etc.
vnoremap <leader>$[ <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>$( <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>${ <esc>`>a}<esc>`<i{<esc>
vnoremap <leader>$>{ ><esc>`>o}<esc><<`<O{<esc>
vnoremap <leader>$" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>$' <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>$` <esc>`>a`<esc>`<i`<esc>

" }}}
