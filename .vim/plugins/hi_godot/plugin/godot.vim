aug Godot
    au BufRead *.tscn :set ft=godot
    au FileType godot :call InitGodotSyntax()
aug END

fu! InitGodotSyntax()
    "setfiletype config
    "set syntax=config
    syntax include @GD3 syntax/gdscript3.vim
    syntax include @GDCONF syntax/config.vim
    ":syntax include @CPP syntax/cpp.vim
    "syntax region gdMain matchgroup=Foo start="\[" end="\]" keepend contains=@GDCONF
    syntax region gdSnip matchgroup=Snip start=+script/source = \"+ skip=+\\"+ end=+"\n+ keepend contains=@GD3
    "hi link Snip SpecialComment

    "syn sync fromstart

    "set syntax=cpp

    "hi! link yamlBlockMappingKey Keyword
    "hi! link yamlBlockCollectionItemStart Function

    ""au FileType yaml hi! link yamlPlainScalar Function
    ""au FileType yaml hi! link yamlFlowString Keyword

    "setlocal ts=2 sts=2 sw=2 expandtab
endf
