" hi pythonFunction ctermfg=blue
" syntax match pythonStatement "\<def\>" conceal cchar=D
" syntax keyword Statement lambda conceal cchar=λ

" setlocal conceallevel=1


" we need the conceal feature (vim ≥ 7.3)
if !has('conceal')
    finish
endif

" remove the keywords. we'll re-add them below
syntax clear pythonOperator

syntax match pythonOperator "\<is\>"

syntax match pyNiceOperator "\<in\>" conceal cchar=∈
syntax match pyNiceOperator "\<or\>" conceal cchar=∨
syntax match pyNiceOperator "\<and\>" conceal cchar=∧
" include the space after “not” – if present – so that “not a” becomes “¬a”.
" also, don't hide “not” behind  ‘¬’ if it is after “is ”.
" syntax match pyNiceOperator "\%(is \)\@<!\<not\%( \|\>\)" conceal cchar=¬
syntax match pyNiceOperator "\<not in\>" conceal cchar=∉
syntax match pyNiceOperator "<=" conceal cchar=≤
syntax match pyNiceOperator ">=" conceal cchar=≥
" only conceal “==” if alone, to avoid concealing SCM conflict markers
" syntax match pyNiceOperator "=\@<!===\@!" conceal cchar=≡
syntax match pyNiceOperator "!=" conceal cchar=≢

syntax keyword pyNiceOperator sum conceal cchar=∑
syntax keyword pyNiceOperator def conceal cchar=
" syntax keyword pyNiceOperator class conceal cchar=
" syntax keyword pyNiceOperator return conceal cchar=↲
" syntax keyword pyNiceOperator self conceal cchar=
syntax keyword pyNiceOperator None conceal cchar=∅
syntax match pyNiceOperator "\<\%(\%(math\|np\|numpy\)\.\)\?sqrt\>" conceal cchar=√
syntax match pyNiceKeyword "\<\%(\%(math\|np\|numpy\)\.\)\?pi\>" conceal cchar=π
syntax match pyNiceOperator "\( \|\)\*\*\( \|\)2\>" conceal cchar=²
syntax match pyNiceOperator "\( \|\)\*\*\( \|\)3\>" conceal cchar=³

syntax keyword pyNiceStatement lambda conceal cchar=λ
syntax keyword pyNiceStatement pass conceal cchar=―
" syntax keyword pyNiceStatement from conceal cchar=
" syntax keyword pyNiceStatement import conceal cchar=.
syntax match pyNiceStatement "\.\.\." conceal cchar=…

hi link pyNiceOperator Operator
hi link pyNiceStatement Statement
hi link pyNiceKeyword Keyword
hi! link Conceal Operator

setlocal conceallevel=1
