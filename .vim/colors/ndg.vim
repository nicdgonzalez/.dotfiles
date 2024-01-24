if &t_Co < 256 && !has('gui_running')
    finish  " Terminal does not support 256 colors and not using gVim
endif

let g:colors_name = 'ndg'

func! GetPalette(hue) abort
    " I know you can't just increment lightness alone to create a palette.
    " I understand the concept, but I have not implemented it yet.
    return {
                \   '050': colors#hsl(a:hue, 0.50, 0.95),
                \   '100': colors#hsl(a:hue, 0.50, 0.90),
                \   '200': colors#hsl(a:hue, 0.50, 0.80),
                \   '300': colors#hsl(a:hue, 0.50, 0.70),
                \   '400': colors#hsl(a:hue, 0.50, 0.60),
                \   '500': colors#hsl(a:hue, 0.50, 0.50),
                \   '600': colors#hsl(a:hue, 0.50, 0.40),
                \   '700': colors#hsl(a:hue, 0.50, 0.30),
                \   '800': colors#hsl(a:hue, 0.50, 0.20),
                \   '900': colors#hsl(a:hue, 0.50, 0.10),
                \   '950': colors#hsl(a:hue, 0.50, 0.05),
                \ }
endfunc

let hue_red = 0
let hue_orange = 30
let hue_cyan = 175
let hue_blue = 210
let hue_purple = 270

let hue_base = 210

let red = GetPalette(0)
let orange = GetPalette(30)
let cyan = GetPalette(175)
let blue = GetPalette(210)
let purple = GetPalette(270)

let g = {}

" See `:help highlight-groups`
let g.normal = {
            \   'guibg': blue.950,
            \   'guifg': blue.050
            \ }
let g.colorcolumn = {
            \   'guibg': red.600
            \ }
let g.linenr = {
            \   'guibg': g.normal.guibg,
            \   'guifg': g.normal.guifg
            \ }
let g.linenrabove = {
            \   'guibg': g.linenr.guibg,
            \   'guifg': colors#adjust(blue.700, {'saturation': -0.30}),
            \ }
let g.linenrbelow = g.linenrabove
let g.folded = {
            \   'guibg': g.linenrabove.guibg,
            \   'guifg': colors#hsl(hue_cyan, 0.7, 0.50),
            \ }
let g.foldcolumn = g.folded
let g.matchparen = {
            \   'guibg': 'NONE',
            \   'guifg': colors#hsl(hue_blue, 0.5, 0.5),
            \ }
let g.pmenu = {
            \   'guibg': colors#adjust(g.normal.guibg, {
            \       'lightness': +0.03,
            \   })
            \ }
let g.statusline = {
            \   'cterm': 'NONE',
            \   'guibg': blue.800,
            \   'guifg': g.normal.guifg,
            \ }
let g.statuslinenc = {
            \   'cterm': 'NONE',
            \   'guibg': blue.900,
            \   'guifg': g.normal.guifg,
            \ }
let g.signcolumn = {
            \   'guibg': g.linenrabove.guibg,
            \ }
let g.vertsplit = {
            \   'cterm': 'NONE',
            \   'guibg': 'NONE',
            \   'guifg': g.statuslinenc.guifg,
            \ }
let g.cursorcolumn = {
            \   'guibg': colors#adjust(g.normal.guibg, {
            \       'saturation': +0.10,
            \       'lightness': +0.20,
            \   }),
            \   'guifg': g.normal.guifg,
            \ }
let g.cursorline = {
            \   'cterm': 'NONE',
            \   'guibg': blue.900,
            \   'guifg': 'NONE',
            \ }
let g.directory = {
            \   'guibg': 'NONE',
            \   'guifg': colors#hsl(hue_base, 0.85, 0.70),
            \ }
let g.endofbuffer = g.normal
let g.visual = g.cursorcolumn


let g.comment = {
            \   'cterm': 'NONE',
            \   'guifg': colors#adjust(blue.400, {'saturation': -0.40}),
            \ }
let g.constant = {
            \   'guifg': colors#adjust(blue.300, {'saturation': +0.50}),
            \ }
let g.string = {
            \   'guifg': colors#adjust(blue.200, {'saturation': +0.50}),
            \ }
let g.identifier = {
            \   'cterm': 'NONE',
            \   'guifg': g.normal.guifg,
            \ }
let g.special = {
            \   'guifg': colors#hsl(hue_base, 0.8, 0.93),
            \ }
let g.title = {'guifg': orange.500}
let g.preproc = {
            \   'guifg': colors#hsl(hue_base, 0.85, 0.7),
            \ }
let g.statement = g.preproc
let g.todo = {
            \   'guibg': 'NONE',
            \   'guifg': colors#hsl(hue_red, 0.85, 0.65),
            \ }
let g.type = {
            \   'guifg': colors#hsl(hue_orange, 1.0, 0.67),
            \ }

let g.pythonBuiltin = g.constant
let g.pythonDecorator = {
            \   'cterm': 'NONE',
            \   'guifg': colors#hsl(hue_purple, 1.0, 0.83),
            \ }
let g.pythonDecoratorName = g.pythonDecorator
let g.pythonFunction = {
            \   'cterm': 'NONE',
            \   'guifg': colors#hsl(hue_purple, 1.0, 0.83),
            \ }
" }}}


call colors#update_theme(g)
