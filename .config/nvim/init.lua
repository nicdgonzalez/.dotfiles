--[[
 _       _ _     _
(_)_ __ (_) |_  | |_   _  __ _
| | '_ \| | __| | | | | |/ _` |
| | | | | | |_ _| | |_| | (_| |
|_|_| |_|_|\__(_)_|\__,_|\__,_|

Maintainer: Nicolas Gonzalez

If you want to try out this setup, run the following commands:

    git clone https://github.com/nicdgonzalez/.dotfiles && cd .dotfiles
    nvim -u '$PWD/.config/nvim/init.lua'

--]]

-- I don't want to maintain two separate configurations for Vim and Neovim,
-- so here I am executing my `.vimrc` file from Lua; ensure both files exist
-- and are in the proper locations before continuing.
vim.cmd [[

" Load the existing Vim configuration
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

try
    " For users testing this setup, I'll prioritize the relative path.
    source ../../.vimrc
catch
    source $HOME/.vimrc
endtry

]]
