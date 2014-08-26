" Vim plugin to cleanup a module according to BDE standards
" @author   Ben Hipple
" @ dependencies:
source ~/.vim/bundle/bde_plugins/class_formatters.vim
source ~/.vim/bundle/bde_plugins/cpp_h_template.vim

function! Bde_Format()
    " Remove tabs and EOL whitespaces
    call StripTabsAndTrailingWhitespaces()

    " Fix filename and language tag
    let firstline = getline(1)
    let reg = '// ' . expand('%:t')
    if(firstline !~ reg)
        normal gg
        put!=XH_FilenameLanguageCommentTag()
    endif

    " Proper class subsection indentation
    %s/^public:$/  public:/ge
    %s/^private:$/  private:/ge

    " TODO
    " find namespace BloombergLP, find the {, hit %, see if the closing
    " bracket has a // close BloombergLP comment

    " TODO
    " For each class, if it doesn't have a comment within 2 lines above it,
    " add the class section comment.  Only match "class \a*\s*{\=$" to avoid
    " forward class declarations!  I.e., look for class lines that don't have
    " a semicolon


endfunction

function! StripTabsAndTrailingWhitespaces()
  let _s=@/
  retab
  %s/\s\+$//e
  let @/=_s
  exec "normal ``"
endfunction

" Optional second argument specifies what character to use for comment (if not in C/C++)
function! CmtSection(title, ...)
    let commentChar = "/"
    if(a:0 == 1)
        let commentChar = a:1
    endif

    let str = commentChar . commentChar . " ============================================================================\n"
    let str = str . commentChar . commentChar . " "

    let startCol = XH_CenteredStringStartColumn(a:title) - strlen("// ") - 1
    let ct = 0
    while ct < startCol
        let str = str . " "
        let ct += 1
    endwhile

    let str = str . a:title . "\n"
    let str = str . commentChar . commentChar . " ============================================================================"
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
