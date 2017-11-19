function! Compl(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && (len(matchstr(line[start - 1], '[a-zA-Z_]')) != 0)
            let start -= 1
        endwhile
        return start
    else
        let expr = ''
        for c in split(a:base, '\zs')
            if len(expr) == 0
                let expr .= c
            else
                let expr .= '[a-zA-Z0-9_]*' . c
            endif
        endfor
        let current_line = 0
        let line_count = line('$')
        echo current_line
        echo line_count
        let matches = []
        while current_line < line_count
            call substitute(getline(current_line), '[a-zA-Z_][a-zA-Z0-9_]*', '\=add(matches, submatch(0))', 'g')
            "let m = matchstr(getline(current_line), '[a-zA-Z_][0-9]\*')
            "echo matches
            let current_line += 1
        endwhile
        let results = []
        for m in matches
            "echo m
            "echo expr
            "echo x
            if len(matchstr(m, expr))
                "echo 'MATCHED ' . m
                "echo x
                call add(results, m)
            endif
        endfor
        return results
        "return [a:base . 'aa', a:base . 'ab', a:base . 'ac']
    endif
endfunction

" SuperTab
let g:SuperTabDefaultCompletionType = "<C-X><C-U>"
inoremap <C-p> <C-X><C-U>
set completefunc=Compl

" Completion tweaks
inoremap <expr> <Esc>      pumvisible() ? "\<C-o>\<Esc>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
"inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

