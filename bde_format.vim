" Vim plugin to cleanup a module according to BDE standards
" @author Ben Hipple
"
" @ dependencies:
source ~/.vim/bundle/bde_plugins/class_formatters.vim
source ~/.vim/bundle/bde_plugins/cpp_h_template.vim

" WIP (relative path sourcing)
"exec "source " . expand("%:p:h") . "/class_formatters.vim"
"exec "source " . expand("%:p:h") . "/cpp_h_template.vim"
"
function! Bde_Format(...)
    " Save current cursor location
    let lineNo=line('.')

    if(a:0 == 1 && a:1 == "clang")
        " TODO - just use the shellscript clang
        exec "silent w"
        cd %:h
        exec "!clang-format -i -style=file " . expand('%:t')

        " Visual selection doesn't seem to work
        "exec "normal! ggVG"
        "exec ":pyf ~/bin/clang-format.py<CR>"
    endif

    " Fix filename and language tag
    let firstline = getline(1)
    let reg = '// ' . expand('%:t')
    normal! gg
    if(firstline !~ reg)
        put!=s:FilenameLanguageCommentTag()
    elseif(len(firstline) != 79)
        normal! dd
        put!=s:FilenameLanguageCommentTag()
    endif

    call FixIncludeGuard()

    " Fix RCSID spacing
    %s/^\([A-Z]*_IDENT_RCSID([A-z_]*,\) /\1/ge

    " Restore line
    exec "normal! " . lineNo . "gg"
    exec "normal! zz"

endfunction

