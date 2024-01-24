
func! Limit(value, min, max) abort
    return a:value >= a:min ? (a:value <= a:max ? a:value : a:max) : a:min
endfunc


" Calculating Hue from RGB:
"   https://stackoverflow.com/a/39147465
" The Difference Between Chroma and Saturation:
"   https://munsell.com/color-blog/difference-chroma-saturation/
func! RGB2HSL(r, g, b) abort
    " Scale the RGB values to fill the [0,1] interval.
    let [l:red, l:green, l:blue] = [
                \   Limit(a:r / 255.0, 0.0, 1.0),
                \   Limit(a:g / 255.0, 0.0, 1.0),
                \   Limit(a:b / 255.0, 0.0, 1.0),
                \ ]

    let l:sorted = sort([l:red, l:green, l:blue], 'f')
    let [l:min, l:max] = [l:sorted[0], l:sorted[-1]]
    let l:chroma = l:max - l:min

    " Lightness is the average of the smallest and largest color component.
    let l:lightness = (l:min + l:max) / 2.0

    if l:chroma == 0
        let l:saturation = 0
    else
        let l:saturation = l:chroma / (1.0 - abs(2.0 * l:lightness - 1.0))
    endif

    if l:chroma == 0
        let l:hue = 0
    else

        if l:max == l:red
            let l:segment = (l:green - l:blue) / l:chroma
            let l:shift = 0.0 / 60.0  " R° / (360° / hex sides)

            if (l:segment < 0.0)  " hue > 180, full rotation
                let l:shift = 360.0 / 60.0
            endif

            let l:hue = l:segment + l:shift
        elseif l:max == l:green
            let l:segment = (l:blue - l:red) / l:chroma
            let l:shift = 120.0 / 60.0  " G° / (360° / hex sides)
            let l:hue = l:segment + l:shift
        elseif l:max == l:blue
            let l:segment = (l:red - l:green) / l:chroma
            let l:shift = 240.0 / 60.0  " B° / (360° / hex sides)
            let l:hue = l:segment + l:shift
        endif

        let l:hue = l:hue * 60  " Hue is in [0,6], scale it up
    endif

    return [l:hue, l:saturation, l:lightness]
endfunc


func! GetColor(hue, tmp1, tmp2) abort
    if a:hue * 6.0 < 1.0
        let l:value = a:tmp2 + (a:tmp1 - a:tmp2) * 6.0 * a:hue
    elseif a:hue * 2.0 < 1.0
        let l:value = a:tmp1
    elseif a:hue * 3.0 < 2.0
        let l:value = a:tmp2 + (a:tmp1 - a:tmp2) * (0.666 - a:hue) * 6.0
    else
        let l:value = a:tmp2
    endif

    return Limit(l:value * 255.0, 0.0, 255.0)
endfunc


func! ValidateColor(color) abort
    return Limit(a:color, 0.0, 255.0)
endfunc


func! ValidateTempColor(color) abort
    let l:value = a:color

    while l:value > 1.0
        let l:value -= 1.0
    endwhile

    while l:value < 0
        let l:value += 1.0
    endwhile

    return l:value
endfunc


func! GetColor(hue, tmp1, tmp2) abort
    if a:hue * 6.0 < 1.0
        let l:value = a:tmp2 + (a:tmp1 - a:tmp2) * 6.0 * a:hue
    elseif a:hue * 2.0 < 1.0
        let l:value = a:tmp1
    elseif a:hue * 3.0 < 2.0
        let l:value = a:tmp2 + (a:tmp1 - a:tmp2) * (0.666 - a:hue) * 6.0
    else
        let l:value = a:tmp2
    endif

    return ValidateColor(l:value * 255.0)
endfunc


func! HSL2RGB(h, s, l) abort
    let [l:hue, l:saturation, l:lightness] = ValidateHSL(a:h, a:s, a:l)

    if l:saturation == 0.0  " Indicates the value is a shade of gray.
        let l:color = l:lightness * 255.0
        return [l:color, l:color, l:color]
    endif

    " Adjust the lightness based on the saturation.
    if l:lightness < 0.5
        let l:tmp1 = l:lightness * (1.0 + l:saturation)
    else
        let l:tmp1 = l:lightness + l:saturation - (l:lightness * l:saturation)
    endif

    let l:tmp2 = (2.0 * l:lightness) - l:tmp1

    let l:hue = l:hue / 360.0  " Scale degrees to fit in [0,1]

    " Shift hue to their respective point in the color wheel.
    let l:tmp_r = ValidateTempColor(l:hue + 0.333)
    let l:tmp_g = ValidateTempColor(l:hue)
    let l:tmp_b = ValidateTempColor(l:hue - 0.333)

    let l:rgb = []

    for hue in [l:tmp_r, l:tmp_g, l:tmp_b]
        let l:rgb = add(l:rgb, GetColor(hue, l:tmp1, l:tmp2))
    endfor

    return l:rgb
endfunc


func! RGB2Hex(r, g, b) abort
    let l:hex = printf(
                \   "#%02X%02X%02X",
                \   float2nr(a:r),
                \   float2nr(a:g),
                \   float2nr(a:b)
                \ )
    return l:hex
endfunc


func! ValidateHue(hue) abort
    let l:value = a:hue

    while l:value > 360.0
        let l:value -= 360.0
    endwhile

    while l:value < 0.0
        let l:value += 360.0
    endwhile

    return Limit(l:value, 0.0, 360.0)
endfunc


func! ValidateSaturation(saturation) abort
    return Limit(a:saturation, 0.0, 1.0)
endfunc


func! ValidateLightness(lightness) abort
    return Limit(a:lightness, 0.0, 1.0)
endfunc


func! ValidateHSL(h, s, l) abort
    return [
                \   ValidateHue(a:h),
                \   ValidateSaturation(a:s),
                \   ValidateLightness(a:l),
                \ ]
endfunc


func! colors#hsl(h, s, l) abort
    let [l:hue, l:saturation, l:lightness] = ValidateHSL(a:h, a:s, a:l)
    let [l:red, l:green, l:blue] = HSL2RGB(l:hue, l:saturation, l:lightness)
    return RGB2Hex(l:red, l:green, l:blue)
endfunc


func! ValidateRGB(r, g, b) abort
    return [ValidateColor(a:r), ValidateColor(a:g), ValidateColor(a:b)]
endfunc


func! colors#rgb(r, g, b) abort
    let [l:red, l:green, l:blue] = ValidateRGB(a:r, a:g, a:b)
    return RGB2Hex(l:red, l:green, l:blue)
endfunc


func! Hex2RGB(hex) abort
    let l:values = [
                \   str2nr(strpart(a:hex, 1, 2), 16),
                \   str2nr(strpart(a:hex, 3, 2), 16),
                \   str2nr(strpart(a:hex, 5, 2), 16),
                \ ]
    return l:values
endfunc


func! colors#adjust(hex, options) abort
    let [l:red, l:green, l:blue] = Hex2RGB(a:hex)
    let [l:hue, l:saturation, l:lightness] = RGB2HSL(l:red, l:green, l:blue)

    let l:hue = ValidateHue(
                \   l:hue + get(a:options, 'hue', 0.0)
                \ )
    let l:saturation = ValidateSaturation(
                \   l:saturation + get(a:options, 'saturation', 0.0)
                \ )
    let l:lightness = ValidateLightness(
                \   l:lightness + get(a:options, 'lightness', 0.0)
                \ )

    let [l:red, l:green, l:blue] = HSL2RGB(l:hue, l:saturation, l:lightness)
    let l:hex = RGB2Hex(l:red, l:green, l:blue)
    return l:hex
endfunc


func! Highlight(group, cterm, ctermbg, ctermfg, guibg, guifg, guisp) abort
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
endfunc


func! colors#update_theme(groups) abort
    for group in keys(a:groups)
        call Highlight(
                    \   group,
                    \   get(a:groups[group], 'cterm', ''),
                    \   get(a:groups[group], 'ctermbg', ''),
                    \   get(a:groups[group], 'ctermfg', ''),
                    \   get(a:groups[group], 'guibg', ''),
                    \   get(a:groups[group], 'guifg', ''),
                    \   get(a:groups[group], 'guisp', ''),
                    \ )
    endfor
endfunc

" For Debugging {{{
func! SynStack() abort
    for i1 in synstack(line('.'), col('.'))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunc

nmap <leader>gm :call SynStack()<cr>
" }}}
