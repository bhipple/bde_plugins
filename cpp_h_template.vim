" Vim plugin to assist with making standard .cpp/.h file pairs using
"     basic templates that are roughly compliant with BDE standards
"
" @author   Ben Hipple
" @date     6/27/2014
"
" @usage -  From any Vim window, :call MkClassFile("namespace", "my_file_name") to make one cpp/h pair.
"           my_file_name is the name to use, minus the namespace prefix
"
"           To make several, :call BatchMkClassFile("MyPackage", "my_file_name1", "my_file_name2", "my_file_name3", ...)
"
"           To make a GTest template based on your current open cpp|h file, :call MkGtest
"
" @depends  class_formatters.vim

" Call to write a single cpp/h pair
function! MkClassFile(namespace, shortFilename)
    "---------------------- CONFIGURABLE VARIABLES -----------------------"
    let openingComment = ""

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let fullFilename = a:namespace . "_" . a:shortFilename

    exec "tabe " . fullFilename . ".cpp"
    exec "silent w"
    exec s:MakeCPP(fullFilename, a:shortFilename, a:namespace, openingComment)
    exec "silent w"

    exec "vsp " . fullFilename . ".h"
    exec "silent w"
    exec s:MakeHeader(fullFilename, a:shortFilename, a:namespace, openingComment)
    exec "silent w"

endfunction

" Calls MkClassFile for every filename given in the variable length arglist.
function! BatchMkClassFile(namespace, ...)
    for fileName in a:000
        silent call MkClassFile(a:namespace, fileName)
    endfor
endfunction

" Put the BDE filename and language tag
function! Bde_FilenameLanguageTag()
    put!=s:FilenameLanguageCommentTag()
endfunction

" Google Test
function! MkGtest()
    cd %:h
    let filename = expand('%:t:r')
    let extension = expand('%:e')

    let namespaces = FindNamespaces()

    exec "vsp " . filename . ".t.cpp"
    let str = s:FilenameLanguageCommentTag()
    let str = str . "#include <" . filename . ".h>\n\n"
    let str = str . "// Application Includes\n\n"
    let str = str . "// BDE Includes\n\n"
    let str = str . "// System Includes\n"
    let str = str . "#include <gtest/gtest.h>\n\n"

    let str = str . "using namespace BloombergLP;\n"
    let ns = "MY_NAMESPACE"
    for [nsName, nsLine] in namespaces
        if(nsName != "BloombergLP" && nsName != "anonymous")
            let ns = nsName
        endif
    endfor
    let str = str . "using namespace BloombergLP::" . ns . ";\n\n"

    let str = str . s:CmtSection("Test Fixtures", "/") . "\n\n"
    let str = str . s:CmtSection("Tests", "/")

    put!=str
endfunction


" =============================================================================
" Private Helper functions
"
function! s:MakeHeader(fullFilename, classStr, namespace, openingComment)
    let classname = s:CalcClassName(a:classStr)

    let str = s:FilenameLanguageCommentTag()
    let str = str . "#ifndef " . s:CalcIncludeGuard(a:fullFilename) . "\n#define " . s:CalcIncludeGuard(a:fullFilename) . "\n\n"

    let str = str . "// Application Includes\n\n"
    let str = str . "// System Includes\n\n"
    let str = str . s:OpenNamespace(a:namespace)
    put!=str
    call Class(classname)
    normal j
    let str = s:CloseNamespace(a:namespace)

    let str = str . "#endif\n\n"
    "let str = str . s:CopyrightString()

    put!=str
endfunction

function! s:MakeCPP(filename, shortFilename, namespace, openingComment)
    let str = s:FilenameLanguageCommentTag()
    let str = str . "#include <" . a:filename . ".h>\n\n"
    let str = str . "// Application Includes\n\n"
    let str = str . "// BDE Includes\n\n"
    let str = str . "// System Includes\n\n"

    let str = str . s:OpenNamespace(a:namespace)
    let str = str . s:AnonymousNamespace(toupper(s:CalcClassName(a:shortFilename)))
    let str = str . s:CloseNamespace(a:namespace)

    put!=str
endfunction

function! s:OpenNamespace(namespace)
    let str = "namespace BloombergLP {\n"
    let str = str . "namespace " . a:namespace . " {\n"
    return str
endfunction

function! s:AnonymousNamespace(logcategory)
    let str = "namespace {\n"
    let str = str . 'const char LOG_CATEGORY[] = "' . a:logcategory . "\";\n"
    let str = str . "}\n"
    return str
endfunction


function! s:CloseNamespace(namespace)
    let str = "\n"
    let str = str . "}  // close namespace " . a:namespace . "\n"
    let str = str . "}  // close enterprise namespace" . "\n\n"
    return str
endfunction

" Default classname replaces filename's first character with a capital letter,
" removes underscores, and capitalizes the subsequent letter
function! s:CalcClassName(filename)
    let classname = substitute(a:filename, '^s_', '', "g")
    let classname = substitute(classname, '^[a-z]', '\U\0', "g")
    let classname = substitute(classname, '_\([a-z]\)', '\U\1', "g")
    return classname
endfunction

" BDE Prologue - Section 4.2 and 5.3
function! s:FilenameLanguageCommentTag()
    let filename = expand('%:t:r')
    let filetype = expand('%:e')
    let str = "// " . filename . '.' . filetype

    " BDE Specified Language tag, right justified to the 79th column
    let languageTag = '-*-C++-*-'
    let spaceCt = 79 - (strlen("// ") + strlen(filename) + 1 + strlen(filetype) + strlen(languageTag))

    let ct = 0
    while(ct < spaceCt)
        let str = str . " "
        let ct += 1
    endwhile

    let str = str . languageTag . "\n"
    return str
endfunction

function! s:CalcIncludeGuard(filename)
    return "INCLUDED_" . toupper(a:filename)
endfunction
