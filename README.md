bde_plugins
===========
Largely deprecated, in favor of UltiSnips. Starting to move code into snippets and generic helper functions


Tools for creating and formatting code according to BDE Standards  

* cpp code reformatting  
* cpp|h file creation  
* Google Test file and test fixture creation  


#### Suggested Mappings
##### Functions
`nnoremap <Leader>fmt :call Bde_Format()<CR>`  
`nnoremap <Leader>cmt :call CmtSection("")<Left><Left>`  
`nnoremap <Leader>w :call StripTabsAndTrailingWhitespaces()<CR>`  
##### Include Sections
`nnoremap <Leader>ia O// Application Includes<ESC>`  
`nnoremap <Leader>ib O// BDE Includes<ESC>`  
`nnoremap <Leader>is O// System Includes<ESC>`  
`nnoremap <Leader>ii O// Application Includes<CR>// BDE Includes<CR>// System Includes<ESC>`  
##### Bael Log
`inoremap <F2> BAEL_LOG_TRACE << `  
`inoremap <F3> BAEL_LOG_DEBUG << `  
`inoremap <F4> BAEL_LOG_ERROR << `  
`inoremap <F5> << BAEL_LOG_END;<ESC>`  
