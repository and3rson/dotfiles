fu GetWindowWidth()
    redir =>l:a |exe "sil sign place buffer=".bufnr('')|redir end
    let l:signlist=split(l:a, '\n')
    let width=winwidth('%') - &numberwidth - &foldcolumn - (len(signlist) > 2 ? 2 : 0)
    return width
endf
