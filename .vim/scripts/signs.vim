" Custom signs
"nnoremap <silent> mmm <Nop>
let i = 0
while i < 10
    exe 'sign define Sign_'.i.' text='.i.' texthl=Function'
    exe 'nnoremap <silent> mm'.i.' :call SignPlace('.i.')<CR>'
    exe 'nnoremap <silent> m'.i.' :call SignJump('.i.')<CR>'
    let i = i + 1
endwhile

function! EnsureSigns()
    if ! exists('b:signs')
        let b:signs = 1
        let b:sign_line_to_id = {}
        let b:sign_id_to_line = {}
    endif
endfunction

function! SignPlace(id)
    call EnsureSigns()

    let exists = has_key(b:sign_line_to_id, line('.'))
    let is_same = 0
    if exists && (b:sign_line_to_id[line('.')] ==# a:id)
        let is_same = 1
    endif

    if exists
        exe 'sign unplace '.(line('.')+4000000).' buffer='.buffer_number('.')
        let old_id= b:sign_line_to_id[line('.')]
        unlet b:sign_line_to_id[line('.')]
        unlet b:sign_id_to_line[old_id]
    endif
    if ! is_same
        if has_key(b:sign_id_to_line, a:id)
            echo 'EXISTS'
            exe 'sign unplace '.(b:sign_id_to_line[a:id]+4000000).' buffer='.buffer_number('.')
        endif
        exe 'sign place '.(line('.')+4000000).' line='.line('.').' name=Sign_'.a:id.' buffer='.buffer_number('.')
        let b:sign_line_to_id[line('.')] = a:id
        let b:sign_id_to_line[a:id] = line('.')
    endif
endfunction

function! SignJump(id)
    call EnsureSigns()

    if has_key(b:sign_id_to_line, a:id)
        exe ':'.b:sign_id_to_line[a:id]
    else
        echo 'Sign ' . a:id . ' not found'
    endif
endfunction

