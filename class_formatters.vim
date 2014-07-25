" Vim plugin to make a new Class or reformat existing text
" @author   Ben Hipple


" From any Vim window, :call Class("classname") to put a class
function! Class(classname)
    let str = XH_Class(a:classname)
    put!=str
endfunction

" Add the:
"         // =============
"         // class MyClass
"         // =============
" prefix comment
"
" Uses either a string parameter or the word under the cursor for the Class name
function! CmtClass(...)
    let classname = ""
    if a:0 == 1
        let classname = a:1
    else
        let classname = expand('<cword>')
    endif

    let str = ""
    let equalSignLine = ""
    let indentStr = ""

    " Calculate the number of equal signs
    let ct = 0
    while(ct < strlen('class ') + strlen(classname))
        let equalSignLine = equalSignLine . "="
        let ct += 1
    endwhile

    " If classname is <20 characters, indent 25 spaces
    " Otherwise, the comment should be centered
    if(strlen(classname) < 20)
        let indentStr = '                        '
    else
        let midpointColumn = (strlen(classname) + strlen('// class ')) / 2
        let indentNumber = 40 - midpointColumn

        let i = 0
        while(i < indentNumber)
            let indentStr = indentStr . ' '
            let i += 1
        endwhile
    endif

    let equalSignLine = indentStr . '// ' . equalSignLine . "\n"
    let str = equalSignLine
    let str = str . indentStr . '// class ' . classname . "\n"
    let str = str . equalSignLine

    put!=str
endfunction


" =============================================================================
" Private Helper functions
"
function! XH_Class(classname)
    " 4 indent
    let indentSize = '    '

    call CmtClass(a:classname)
    normal j
    let str = ""
    let str = str . "class " . a:classname . " {\n"
    let str = str . "  public:\n"

    let str = str . indentSize . '// CREATORS' . "\n"
    " Constructor
    let str = str . indentSize . '//' . a:classname . '() { }' . "\n"
    " Copy Constructor
    let str = str . indentSize . '//' . a:classname . '(const ' . a:classname . '&);' . "\n"
    " Destructor
    let str = str . indentSize . '//~' . a:classname . '() { }' . "\n\n"

    let str = str . "  private:\n"
    " Copy Assignment Operator
    let str = str . indentSize . '//' . a:classname . '& operator=(const ' . a:classname . '&);' . "\n\n"

    let str = str . "\n};" . "\n"
    return str
endfunction
