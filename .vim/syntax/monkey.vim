" Vim Syntax File
" Language: Monkey
" Maintainer: Nicolas Gonzalez
" Latest Revision: 2024-01-23

if exists('b:current_syntax')
    finish
endif

syn keyword monkeyStatement let return

let b:current_syntax = 'monkey'

hi def link monkeyStatement Statement
