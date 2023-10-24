" Vim syntax file
" Language:	GINGER vector file
" Maintainer:	Andrew Dunai <a@dun.ai>
" Last Change:	2023 Oct 8

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" this language is oblivious to case.
syn region vecTestName start=+^@+ end=+$+
syn region vecInputs start=+<+ end=+$+
syn region vecOutputs start=+>+ end=+$+
syn region vecVector start=+[01]+ end=+$+
syn region vecAssertion start=+?+ end=+$+


syn match vecComment "#.*$"

syn sync minlines=1

hi def link vecTestName Function
hi def link vecInputs Identifier
hi def link vecOutputs Identifier
hi def link vecVector Normal
hi def link vecAssertion Statement
hi def link vecComment Comment

let b:current_syntax = "vec"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:ts=8
