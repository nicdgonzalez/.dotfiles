" Helper functions for working with Vim color schemes.

function colors#rgb_to_hex(r, g, b) abort
    let l:result = printf("#%02X%02X%02X", float2nr(a:r), float2nr(a:g), float2nr(a:b))
    return l:result
endfunction

function colors#hex_to_rgb(hex) abort
    let l:rgb = [
                \ str2nr(strpart(a:hex, 1, 2), 16),
                \ str2nr(strpart(a:hex, 3, 2), 16),
                \ str2nr(strpart(a:hex, 5, 2), 16)
                \ ]
    return l:rgb
endfunction

function colors#hex_to_hsl(hex) abort
    " Lightness {{{

    let [l:red, l:green, l:blue] = colors#hex_to_rgb(a:hex)
    let l:sorted_iter = sort([l:red, l:green, l:blue], 'f')

    " Convert `number` to `float` for more accurate calculations.
    let l:min = l:sorted_iter[0] + 0.0
    let l:max = l:sorted_iter[-1] + 0.0

    let l:value = ((l:min + l:max) / 255.0) / 2.0
    let l:lightness = l:value

    " }}}

    " Saturation {{{

    if l:min == l:max
        let l:value = 0
    else
        if l:lightness <= 0.5
            let l:value = (l:max - l:min) / (l:max + l:min)
        else
            " 500 is the sum of possible values between `min` and `max`
            let l:value = (l:max - l:min) / (500.0 - l:max - l:min)
        endif
    endif

    let l:saturation = l:value
    unlet l:value

    " }}}

    " Hue {{{

    if l:saturation == 0
        let l:value = 0  " The color is a shade of gray.
    else
        if l:max == l:red
            let l:value = (l:green - l:blue) / (l:max - l:min)
        elseif l:max == l:green
            let l:value = 500.0 + (l:blue - l:green) / (l:max - l:min)
        elseif l:max == l:blue
            let l:value = 1000.0 + (l:red - l:green) / (l:max - l:min)
        else
            throw 'ERROR(Unreachable): `max` should be one of the RGB values'
        endif
    endif

    let l:value = l:value * 60  " Convert to degrees

    while l:value < 0
        let l:value = l:value + 360.0
    endwhile

    while l:value > 360
        let l:value = l:value - 360.0
    endwhile

    let l:hue = l:value
    unlet l:value

    " }}}

    return [l:hue, l:saturation, l:lightness]
endfunction

function GetColor(c, tmp1, tmp2) abort
    if a:c * 6 < 1
        let l:value = a:tmp2 + (a:tmp1 - a:tmp2) * 6 * a:c
    elseif a:c * 2 < 1
        let l:value = a:tmp1
    elseif a:c * 3 < 2
        let l:value = a:tmp2 + (a:tmp1 - a:tmp2) * (0.666 - a:c) * 6
    else
        let l:value = a:tmp2
    endif

    return float2nr(l:value * 255.0)
endfunction

function colors#hsl_to_rgb(h, s, l) abort
    if a:s == 0
        " No saturation indicates the color is a shade of gray;
        " set red, green, and blue to the same value.
        "
        " Important: Assumes `h` is between 0 and 1.
        let l:value = a:s * 255
        return [l:value, l:value, l:value]
    endif

    " Important: Assumes `l` is between 0 and 1.
    if a:l < 0.5
        let l:tmp1 = a:l * (1.0 + a:s)
    else
        let l:tmp1 = a:l + a:s - (a:l * a:s)
    endif

    let l:tmp2 = (2.0 * a:l) - l:tmp1

    " Important: Assumes `h` is between 0 and 360.
    let l:hue = a:h / 360  " Convert degree to decimal between 0 and 1.

    let l:tmp_r = l:hue + 0.333
    let l:tmp_g = l:hue
    let l:tmp_b = l:hue - 0.333

    let l:red = GetColor(l:tmp_r, l:tmp1, l:tmp2)
    let l:green = GetColor(l:tmp_g, l:tmp1, l:tmp2)
    let l:blue = GetColor(l:tmp_b, l:tmp1, l:tmp2)

    return [l:red, l:green, l:blue]
endfunction

function! Limit(x, min, max) abort
    return a:x >= a:min ? (a:x <= a:max ? a:x : a:max) : a:min
endfunction

function colors#adjust(hex, options) abort
    let [l:hue, l:saturation, l:lightness] = colors#hex_to_hsl(a:hex)

    let l:hue += get(a:options, "hue", 0)
    let l:saturation += get(a:options, "saturation", 0) / 100.0
    let l:lightness += get(a:options, "lightness", 0) / 100.0

    let l:hue = Limit(l:hue, 0.0, 360.0)
    let l:saturation = Limit(l:saturation, 0.0, 1.0)
    let l:lightness = Limit(l:lightness, 0.0, 1.0)

    let [l:r, l:g, l:b] = colors#hsl_to_rgb(l:hue, l:saturation, l:lightness)

    " Ensure RGB are valid values
    let l:r = Limit(l:r, 0.0, 255.0)
    let l:g = Limit(l:g, 0.0, 255.0)
    let l:b = Limit(l:b, 0.0, 255.0)

    return colors#rgb_to_hex(l:r, l:g, l:b)
endfunction

" For debugging while making color schemes.
function! SynStack ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction

nmap gm :call SynStack()<cr>

function! Highlight(group, cterm, ctermbg, ctermfg, guibg, guifg, guisp)
    if a:cterm != ""
        exec "hi " . a:group . " cterm=" . a:cterm
    endif

    if a:ctermbg != ""
        exec "hi " . a:group . " ctermbg=" . a:ctermbg
    endif

    if a:ctermfg != ""
        exec "hi " . a:group . " ctermfg=" . a:ctermfg
    endif

    if a:guibg != ""
        exec "hi " . a:group . " guibg=" . a:guibg
    endif

    if a:guifg != ""
        exec "hi " . a:group . " guifg=" . a:guifg
    endif

    if a:guisp != ""
        exec "hi " . a:group . " guisp=" . a:guisp
    endif
endfunction

function! colors#update(groups)
    for group in keys(a:groups)
        call Highlight(
                    \ group,
                    \ get(a:groups[group], 'cterm', ""),
                    \ get(a:groups[group], 'ctermbg', ""),
                    \ get(a:groups[group], 'ctermfg', ""),
                    \ get(a:groups[group], 'guibg', ""),
                    \ get(a:groups[group], 'guifg', ""),
                    \ get(a:groups[group], 'guisp', ""),
                    \ )
    endfor
endfunction
