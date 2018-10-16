hi! TabLineNormal ctermbg=235 ctermfg=255
hi! TabLineActive ctermbg=33 ctermfg=255 cterm=bold

fu TabLineIcon(filetype)
    return has_key(g:ic, a:filetype) ? g:ic[a:filetype] : g:ic.default
endf

fu InitTabLine()
    set tabline=%!RenderTabLine()
    set showtabline=2
endf

fu GetBuffers()
    let l:result = []
    let l:buffers = filter(range(1, bufnr('$')), 'bufexists(v:val) && buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype") && "netrw" != getbufvar(v:val, "&filetype") && "" != getbufvar(v:val, "&filetype")')
	let l:current_buffer = bufnr('%')
    for l:buffer in l:buffers
        "let l:path_parts = split(fnamemodify(bufname(l:buffer), ':p'), '/')
        let l:path_parts = split(bufname(l:buffer), '/')
        let l:unnamed = len(l:path_parts) == 0
        if !l:unnamed
            let l:name = l:path_parts[-1]
            call remove(l:path_parts, -1)
            if len(l:path_parts) > 0
                let l:name = l:path_parts[-1] . '/' . l:name
                call remove(l:path_parts, -1)
            endi
        el
            let l:name = '(new buffer)'
        endi
        let l:type = getbufvar(l:buffer, '&filetype')
        call add(l:result, {
                    \ 'id': l:buffer,
                    \ 'path_parts': l:path_parts,
                    \ 'name': l:name,
                    \ 'is_current': l:current_buffer == l:buffer,
                    \ 'type': l:type,
                    \ 'icon': TabLineIcon(l:type),
                    \ 'unnamed': l:unnamed,
                    \ 'modified': getbufvar(l:buffer, '&modified')
                    \ })
    endfo
    for l:buffer in l:result
        if len(l:buffer.name) > 25
            let l:buffer.name = strcharpart(l:buffer.name, 0, 12) . '…' . strcharpart(l:buffer.name, len(l:buffer.name) - 12)
        endi
    endfo
    return l:result
endf

fu RenderTabLine()
    let l:tabline = ''
    let l:tabline .= '%#TabLineNormal#'
    let l:buffers = GetBuffers()
	for l:buffer in l:buffers
		if l:buffer.is_current
			let l:tabline .= '%#TabLineActive#'
		else
			let l:tabline .= '%#TabLineNormal#'
		end
		let l:tabline .= ' ' . l:buffer.icon . ' ' . l:buffer.name . ' '
        if l:buffer.modified
            let l:tabline .= ' '
        endi
        "let l:tabline .= ' '
	endfo
	let l:tabline .= '%#TabLineNormal#'
    let l:tabline .= '%='
    "let l:tabline .= ' %L'
    "let l:tabline .= ' %R'
    "let l:tabline .= ' %Y '
    return l:tabline
endf

autocmd VimEnter * call InitTabLine()
autocmd TabEnter * call InitTabLine()
autocmd BufAdd * call InitTabLine()
autocmd BufDelete * call InitTabLine()
