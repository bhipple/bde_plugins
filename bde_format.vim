" Vim plugin to cleanup a module according to BDE standards
" @author   Ben Hipple
" @depends  functions.vim, class_formatters.vim

function! Bde_Format()
    " Remove tabs and EOL whitespaces
    call StripTabsAndTrailingWhitespaces()

    " Check for filename and language tag
    " TODO

endfunction
