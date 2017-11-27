" Fast Escape
" https://www.reddit.com/r/vim/comments/2391u5/delay_while_using_esc_to_exit_insert_mode/cgw9xrh/

augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=250
    au InsertEnter * set ttimeoutlen=0
    au InsertLeave * set ttimeoutlen=250
augroup END

inoremap <C-c> <Esc>

