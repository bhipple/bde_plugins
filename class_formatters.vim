" Vim plugin to make a new Class or reformat existing text
" @author   Ben Hipple

" =============================================================================
" Private Helper functions
"
function! s:Class(classname)
    " 4 indent
    let indentSize = '    '

    normal j
    let str = ""
    let str = str . "class " . a:classname . " {\n"
    let str = str . "  public:\n"

    let str = str . indentSize . '// CREATORS' . "\n"
    " Constructor
    let str = str . indentSize . '//' . a:classname . '() { }' . "\n"
    " Copy Constructor
    let str = str . indentSize . '//' . a:classname . '(const ' . a:classname . '&);' . "\n"
    " Copy Assignment Operator
    let str = str . indentSize . '//' . a:classname . '& operator=(const ' . a:classname . '&);' . "\n\n"
    " Destructor
    let str = str . indentSize . '//~' . a:classname . '() { }' . "\n\n"

    let str = str . "  private:\n"

    let str = str . "\n};" . "\n"
    return str
endfunction
