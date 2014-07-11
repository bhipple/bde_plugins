" Vim plugin to cleanup a module according to BDE standards
" @author   Ben Hipple
" @depends  class_formatters.vim

function! Bde_Format()
    " Remove tabs and EOL whitespaces
    call StripTabsAndTrailingWhitespaces()

    " Check for filename and language tag
    " TODO

endfunction


function! StripTabsAndTrailingWhitespaces()
  let _s=@/
  retab
  %s/\s\+$//e
  let @/=_s
  exec "normal ``"
endfunction


function! CmtSection(title)
    let str = "// ============================================================================\n"
    let str = str . "// "

    let startCol = XH_CenteredStringStartColumn(a:title) - strlen("// ") - 1
    let ct = 0
    while ct < startCol
        let str = str . " "
        let ct += 1
    endwhile

    let str = str . a:title . "\n"
    let str = str . "// ============================================================================"
    put!=str
endfunction


" =============================================================================
"                             Helper Functions
" =============================================================================
function! XH_CenteredStringStartColumn(str)
    if strlen(a:str) >= 79
        return 0
    endif

    let midCol = 40
    let strMidptDist = strlen(a:str) / 2
    return midCol - strMidptDist
endfunction
