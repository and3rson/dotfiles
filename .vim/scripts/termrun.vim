fu RunInTerminal() range
    "echo a:firstline . '/' . a:lastline
    let lines = getline(a:firstline, a:lastline)
    let @c = join(lines, nr2char(10)) . nr2char(10)
    :sp
    wincmd j
    :terminal ipython
    normal "cP
    "echo lines
endf

com -range RunInTerminal <line1>,<line2>call RunInTerminal()
nnoremap <M-Enter> :RunInTerminal<CR>
vnoremap <M-Enter> :RunInTerminal<CR>
"nnoremap <silent> <M-t> :sp<CR>:terminal<CR>

