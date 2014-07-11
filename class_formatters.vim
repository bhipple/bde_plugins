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
" Uses either a given string or the word under the cursor for the Class name
function! ClassComment(...)
    if a:0 == 1
        put!=XH_ClassComment(a:1)
    else
        put!=XH_ClassComment(expand('<cword>'))
    endif
endfunction


" =============================================================================
" Private Helper functions
"
function! XH_Class(classname)
    " 4 indent
    let indentSize = '    '

    let str = XH_ClassComment(a:classname)
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

function! XH_ClassComment(classname)
    let str = ""
    let equalSignLine = ""
    let indentStr = ""

    " Calculate the number of equal signs
    let ct = 0
    while(ct < strlen('class ') + strlen(a:classname))
        let equalSignLine = equalSignLine . "="
        let ct += 1
    endwhile

    " If classname is <20 characters, indent 25 spaces
    " Otherwise, the comment should be centered
    if(strlen(a:classname) < 20)
        let indentStr = '                        '
    else
        let midpointColumn = (strlen(a:classname) + strlen('// class ')) / 2
        let indentNumber = 40 - midpointColumn

        let i = 0
        while(i < indentNumber)
            let indentStr = indentStr . ' '
            let i += 1
        endwhile
    endif

    let equalSignLine = indentStr . '// ' . equalSignLine . "\n"
    let str = equalSignLine
    let str = str . indentStr . '// class ' . a:classname . "\n"
    let str = str . equalSignLine

    return str
endfunction
