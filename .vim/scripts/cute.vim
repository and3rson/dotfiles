fu Cute()
    if !has('conceal')
        finish
    endif

    syntax clear pythonOperator

    syntax match pythonOperator "\<is\>"

    syntax match pyNiceOperator "\<in\>" conceal cchar=∈
    syntax match pyNiceOperator "\<or\>" conceal cchar=∨
    syntax match pyNiceOperator "\<and\>" conceal cchar=∧

    syntax keyword pyNiceStatement lambda conceal cchar=λ

    hi link pyNiceOperator Operator
    hi link pyNiceKeyword Keyword
    hi! link Conceal Operator

    set cole=1
endfu

au filetype python call Cute()
