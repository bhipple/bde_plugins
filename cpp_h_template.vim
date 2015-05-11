" Vim plugin to assist with making standard .cpp/.h file pairs using
"     basic templates that are roughly compliant with BDE standards
"
" @author   Ben Hipple
" @date     6/27/2014
"
" @usage -  From any Vim window, :call MkClassFile("MyPackage", "my_file_name") to make one cpp/h pair.
"
"           To make several, :call BatchMkClassFile("MyPackage", "my_file_name1", "my_file_name2", "my_file_name3", ...)
"
"           To make a GTest template based on your current open cpp|h file, :call MkGtest
"
" @depends  class_formatters.vim
"
" @note Helper functions are prefaced with "XH_" to avoid namespace pollution, since I'm not sure how to declare a
"   function private in Vimscript :)


" Call to write a single cpp/h pair
function! MkClassFile(namespace, filename)
    "---------------------- CONFIGURABLE VARIABLES -----------------------"
    let openingComment = ""

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    exec "tabe" a:filename . ".cpp"
    exec "silent w"
    exec XH_MakeCPP(a:filename, a:namespace, openingComment)
    exec "silent w"

    exec "vsp " . a:filename . ".h"
    exec "silent w"
    exec XH_MakeHeader(a:filename, a:namespace, openingComment)
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
    put!=XH_FilenameLanguageCommentTag()
endfunction

" Google Test
function! MkGtest()
    cd %:h
    let filename = expand('%:t:r')
    let extension = expand('%:e')

    let namespaces = FindNamespaces()

    exec "vsp " . filename . ".t.cpp"
    let str = XH_FilenameLanguageCommentTag()
    let str = str . "#include <" . filename . ".h>\n\n"
    let str = str . "// Application Includes\n\n"
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

    let str = str . XH_CmtSection("Test Fixtures", "/") . "\n\n"
    let str = str . XH_CmtSection("Tests", "/")

    put!=str
endfunction


" =============================================================================
" Private Helper functions
"
function! XH_MakeHeader(filename, namespace, openingComment)
    let classname = XH_CalcClassName(a:filename)

    let str = XH_FilenameLanguageCommentTag()
    let str = str . "#ifndef " . XH_CalcIncludeGuard(a:filename) . "\n#define " . XH_CalcIncludeGuard(a:filename) . "\n\n"

    let str = str . XH_OpenNamespace(a:namespace)
    put!=str
    call Class(classname)
    normal j
    let str = XH_CloseNamespace(a:namespace)

    let str = str . "#endif\n\n"
    "let str = str . XH_CopyrightString()

    put!=str
endfunction

function! XH_MakeCPP(filename, namespace, openingComment)

    let str = XH_FilenameLanguageCommentTag()
    let str = str . "#include <" . a:filename . ".h>\n\n"

    let str = str . XH_OpenNamespace(a:namespace)
    let str = str . XH_CloseNamespace(a:namespace)
    "let str = str . XH_CopyrightString()

    put!=str
endfunction

function! XH_OpenNamespace(namespace)
    let str = "namespace BloombergLP {\n"
    let str = str . "namespace " . a:namespace . " {\n\n"
    return str
endfunction

function! XH_CloseNamespace(namespace)
    let str = "\n"
    let str = str . "}  // close namespace " . a:namespace . "\n"
    let str = str . "}  // close enterprise namespace" . "\n\n"
    return str
endfunction


" Default classname replaces filename's first character with a capital letter,
" removes underscores, and capitalizes the subsequent letter
function! XH_CalcClassName(filename)
    let classname = substitute(a:filename, '^[a-z]', '\U\0', "g")
    let classname = substitute(classname, '_\([a-z]\)', '\U\1', "g")
    return classname
endfunction

" BDE Prologue - Section 4.2 and 5.3
function! XH_FilenameLanguageCommentTag()
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

function! XH_CalcIncludeGuard(filename)
    return "INCLUDED_" . toupper(a:filename)
endfunction


" Bloomberg LP Copyright Message
function! XH_CopyrightString()
    let str = "// ----------------------------------------------------------------------------" . "\n"
    let str = str . "// NOTICE:" . "\n"
    let str = str . "//      Copyright (C) Bloomberg L.P., 2015" . "\n"
    let str = str . "//      All Rights Reserved." . "\n"
    let str = str . "//      Property of Bloomberg L.P. (BLP)" . "\n"
    let str = str . "//      This software is made available solely pursuant to the" . "\n"
    let str = str . "//      terms of a BLP license agreement which governs its use." . "\n"
    let str = str . "// ------------------------------- END-OF-FILE --------------------------------"
    return str
endfunction

