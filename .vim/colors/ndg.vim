" @nicdgonzalez's Custom color scheme for Vim (WIP)
"
" My previous theme was Github Dark themed, so I temporarily recreated it here.
" This currently (partially) covers the most basic highlight groups.
"
" This file depends on:
"   * .vim/autoload/colors.vim -- Contains color-adjustment helper functions.

if &t_Co < 256 && !has('gui_running')
    finish  " Terminal does not support 256 colors and not using gVim.
endif

let g:colors_name = 'ndg'

let palette = {}

let palette.White = '#eeeeee'       " Foreground
let palette.Red = '#ff7b72'         " Diff Remove
let palette.LightRed = '#ff7b72'    " Keywords
let palette.Orange = '#ffa657'      " Variables
let palette.LightGreen = '#7ee787'  " Escaped Characters
let palette.Green = '#3fb950'       " Diff Add
let palette.Turquoise = '#62bcb3'   " Fold Column
let palette.LightBlue = '#a5d6ff'   " Strings
let palette.Blue = '#79c0ff'        " Constants
let palette.DarkBlue = '#0e1319'    " Background
let palette.Purple = '#d2a8ff'      " Matching Parenthesis
let palette.Gray = '#8b949e'        " Comments

" The following colors are dependent on the background
let palette.Background = colors#adjust(palette.DarkBlue, {})
let palette.BackAccent = colors#adjust(
            \   palette.Background,
            \   {'lightness': 5}
            \ )
let palette.LineNr = colors#adjust(palette.Background, {'lightness': 75})
let palette.LineNrAbove = colors#adjust(
            \   palette.Background,
            \   {'saturation': -5, 'lightness': 23}
            \ )

let C = {}

" Display {{{

" For the background color and any non-highlighted text.
let C.Normal = {'guibg': palette.Background, 'guifg': palette.White}

" The nth column on the right-hand side when `colorcolumn` is set.
let C.ColorColumn = {'guibg': palette.BackAccent}
let C.Conceal = {}
let C.Cursor = {}
let C.lCursor = {}
let C.CursorIM = {}

" When the cursor hovers on a word, matching words across the file get
" highlighted as well. This is the related group:
let C.CursorColumn = {
            \   'guifg': palette.White,
            \   'guibg': colors#adjust(
            \       palette.DarkBlue,
            \       {'saturation': +10, 'lightness': 20}
            \   ),
            \ }

" The current line when browsing the file tree.
let C.CursorLine = {
            \   'guibg': palette.BackAccent,
            \   'guifg': 'NONE',
            \   'cterm': 'NONE',
            \ }

" Colors the directories in the file tree.
let C.Directory = {'guibg': 'NONE', 'guifg': palette.LightBlue}

let C.DiffAdd = {'guibg': palette.Green, 'guifg': palette.White}
let C.DiffChange = {}
let C.DiffDelete = {
            \   'cterm': 'NONE',
            \   'guibg': palette.Red,
            \   'guifg': palette.White
            \ }
let C.DiffText = {}
let C.EndOfBuffer = {'guibg': C.Normal.guibg, 'guifg': palette.White}
let C.ErrorMsg = {}
let C.VertSplit = {'cterm': 'NONE', 'guibg': 'NONE', 'guifg': palette.White}

let C.Folded = {'guibg': C.CursorLine.guibg, 'guifg': palette.Turquoise}
let C.FoldColumn = {'guibg': palette.BackAccent, 'guifg': palette.Turquoise}

let C.SignColumn = C.FoldColumn
let C.IncSearch = {}
let C.LineNr = {'guibg': C.FoldColumn.guibg, 'guifg': palette.LineNr}
let C.LineNrAbove = {'guibg': C.LineNr.guibg, 'guifg': palette.LineNrAbove}
let C.LineNrBelow = C.LineNrAbove
let C.CursorLineNr = {}
let C.MatchParen = {'guibg': 'NONE', 'guifg': palette.Red}
let C.ModeMsg = {}
let C.MoreMsg = {}
let C.NonText = {}
let C.Pmenu = {'guibg': palette.BackAccent}
let C.PmenuSel = {}
let C.PmenuSbar = {}
let C.PmenuThumb = {}
let C.Question = {}
let C.QuickFixLine = {}
let C.Search = {}
let C.SpecialKey = {}
let C.SpellBad = {}
let C.SpellCap = {}
let C.SpellLocal = {}
let C.SpellRare = {}
let C.StatusLine = {
            \   'cterm': 'NONE',
            \   'guibg': colors#adjust(palette.Background, {'lightness': +10}),
            \   'guifg': palette.White,
            \ }
let C.StatusLineNC = {
            \   'cterm': 'NONE',
            \   'guibg': colors#adjust(palette.Background, {'lightness': 5}),
            \   'guifg': palette.White,
            \ }
let C.StatusLineTerm = C.StatusLine
let C.StatusLineTermNC = C.StatusLineNC
let C.TabLine = {}
let C.TabLineFill = {}
let C.TabLineSel = {}
let C.Terminal = {}
let C.Title = {'guifg': palette.Orange}

" For the selected text in Visual mode.
let C.Visual = C.CursorColumn
let C.VisualNOS = {}
let C.WildMenu = {}
" }}}

" Generic Syntax {{{
let C.Comment = {'guifg': palette.Gray}
let C.Constant = {'guifg': palette.Blue}
let C.Error = {}
let C.String = {'guifg': palette.LightBlue}
let C.Identifier = {'guifg': palette.Orange, 'cterm': 'NONE'}
let C.PreProc = {'guifg': palette.LightRed}
let C.Special = {'guifg': palette.White}
let C.Statement = C.PreProc
let C.Todo = {'guibg': 'NONE', 'guifg': palette.Red}
let C.ToolbarLine = {}
let C.ToolbarButton = {}
let C.Type = {'guifg': palette.Orange}
let C.Underlined = {}
" }}}

" netrw {{{
let C.netrwSymlink = {'guifg': palette.Purple}
let C.netrwClassify = {'guifg': palette.Purple}
" }}}

call colors#update(C)
